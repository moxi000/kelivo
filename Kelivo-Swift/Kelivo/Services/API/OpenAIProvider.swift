import Foundation

// MARK: - OpenAI Provider

/// Implements LLMProvider for the OpenAI Chat Completions API.
/// Also serves as the base for all OpenAI-compatible APIs (local LLMs, third-party proxies, etc.).
final class OpenAIProvider: LLMProvider, @unchecked Sendable {
    let id: String
    let name: String
    let apiType: APIType = .openaiChatCompletions

    private let baseUrl: String
    private let apiKey: String

    init(
        id: String = "openai",
        name: String = "OpenAI",
        baseUrl: String,
        apiKey: String
    ) {
        self.id = id
        self.name = name
        self.baseUrl = baseUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        self.apiKey = apiKey
    }

    // MARK: - Send Message

    func sendMessage(
        messages: [MessagePayload],
        model: String,
        parameters: ModelParameters,
        tools: [ToolDefinition]?
    ) -> AsyncThrowingStream<ChatStreamChunk, Error> {
        let requestBody = buildRequestBody(
            messages: messages, model: model, parameters: parameters, tools: tools)
        let url = URL(string: "\(baseUrl)/v1/chat/completions")!
        let headers = buildHeaders()

        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return AsyncThrowingStream { $0.finish(throwing: OpenAIProviderError.serializationFailed) }
        }

        let rawStream = HTTPClient.shared.stream(url, method: "POST", headers: headers, body: bodyData)
        let sseStream = SSEParser.parse(rawStream)

        return AsyncThrowingStream { continuation in
            let task = Task {
                // Accumulate partial tool calls across deltas
                var toolCallAccumulators: [Int: PartialToolCall] = [:]

                do {
                    for try await event in sseStream {
                        if Task.isCancelled {
                            continuation.finish()
                            return
                        }
                        if let chunk = self.parseSSEEvent(
                            event,
                            toolCallAccumulators: &toolCallAccumulators
                        ) {
                            continuation.yield(chunk)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    // MARK: - Fetch Models

    func fetchModels(baseUrl: String, apiKey: String) async throws -> [RemoteModel] {
        let url = URL(string: "\(baseUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/v1/models")!
        let headers: [String: String] = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json",
        ]

        let (data, _) = try await HTTPClient.shared.request(url, headers: headers)
        let response = try JSONDecoder().decode(OpenAIModelsResponse.self, from: data)

        return response.data.map { model in
            RemoteModel(
                id: model.id,
                displayName: model.id,
                contextWindow: nil,
                maxOutputTokens: nil
            )
        }
    }

    // MARK: - Request Building

    private func buildHeaders() -> [String: String] {
        [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json",
        ]
    }

    private func buildRequestBody(
        messages: [MessagePayload],
        model: String,
        parameters: ModelParameters,
        tools: [ToolDefinition]?
    ) -> [String: Any] {
        var body: [String: Any] = [
            "model": model,
            "stream": true,
            "stream_options": ["include_usage": true],
        ]

        // Convert messages
        body["messages"] = messages.map { message -> [String: Any] in
            var msg: [String: Any] = ["role": message.role]
            msg["content"] = convertContentForOpenAI(message.content)
            return msg
        }

        // Parameters
        if let temperature = parameters.temperature {
            body["temperature"] = temperature
        }
        if let topP = parameters.topP {
            body["top_p"] = topP
        }
        if let maxTokens = parameters.maxTokens {
            body["max_tokens"] = maxTokens
        }
        if let frequencyPenalty = parameters.frequencyPenalty {
            body["frequency_penalty"] = frequencyPenalty
        }
        if let presencePenalty = parameters.presencePenalty {
            body["presence_penalty"] = presencePenalty
        }

        // Reasoning budget for o1/o3 models
        if let budget = parameters.reasoningBudget, budget > 0 {
            body["reasoning_effort"] = reasoningEffortString(budget)
        }

        // Tools
        if let tools = tools, !tools.isEmpty {
            body["tools"] = tools.map { tool -> [String: Any] in
                [
                    "type": "function",
                    "function": [
                        "name": tool.name,
                        "description": tool.description,
                        "parameters": encodeSchemaToDict(tool.parameters),
                    ] as [String: Any],
                ]
            }
        }

        return body
    }

    private func convertContentForOpenAI(_ content: MessageContent) -> Any {
        switch content {
        case .text(let text):
            return text
        case .parts(let parts):
            return parts.map { part -> [String: Any] in
                switch part {
                case .text(let text):
                    return ["type": "text", "text": text]
                case .image(let data, let mimeType):
                    let base64 = data.base64EncodedString()
                    return [
                        "type": "image_url",
                        "image_url": [
                            "url": "data:\(mimeType);base64,\(base64)"
                        ],
                    ]
                }
            }
        }
    }

    /// Map a numeric reasoning budget to OpenAI's reasoning_effort levels.
    private func reasoningEffortString(_ budget: Int) -> String {
        if budget <= 1024 {
            return "low"
        } else if budget <= 8192 {
            return "medium"
        } else {
            return "high"
        }
    }

    // MARK: - SSE Parsing

    private struct PartialToolCall {
        var id: String
        var name: String
        var arguments: String
    }

    private func parseSSEEvent(
        _ event: SSEEvent,
        toolCallAccumulators: inout [Int: PartialToolCall]
    ) -> ChatStreamChunk? {
        guard let data = event.data.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return nil
        }

        let id = json["id"] as? String

        // Parse usage from top level (stream_options include_usage)
        let usage = parseUsage(json["usage"] as? [String: Any])

        guard let choices = json["choices"] as? [[String: Any]],
            let choice = choices.first
        else {
            // Usage-only chunk (final chunk with no choices)
            if usage != nil {
                return ChatStreamChunk(id: id, usage: usage)
            }
            return nil
        }

        let finishReason = choice["finish_reason"] as? String

        guard let delta = choice["delta"] as? [String: Any] else {
            return ChatStreamChunk(id: id, finishReason: finishReason, usage: usage)
        }

        let content = delta["content"] as? String
        let reasoningContent = delta["reasoning_content"] as? String

        // Tool calls
        var toolCalls: [ToolCall]?
        if let deltaToolCalls = delta["tool_calls"] as? [[String: Any]] {
            for tc in deltaToolCalls {
                let index = tc["index"] as? Int ?? 0
                if let function = tc["function"] as? [String: Any] {
                    let tcId = tc["id"] as? String
                    let tcName = function["name"] as? String
                    let tcArgs = function["arguments"] as? String ?? ""

                    if let tcId = tcId {
                        // New tool call
                        toolCallAccumulators[index] = PartialToolCall(
                            id: tcId, name: tcName ?? "", arguments: tcArgs)
                    } else if var existing = toolCallAccumulators[index] {
                        // Append arguments
                        existing.arguments += tcArgs
                        if let name = tcName, !name.isEmpty {
                            existing.name = name
                        }
                        toolCallAccumulators[index] = existing
                    }
                }
            }

            // Emit completed tool calls on finish
            if finishReason == "tool_calls" || finishReason == "stop" {
                toolCalls = toolCallAccumulators.sorted(by: { $0.key < $1.key }).map {
                    ToolCall(id: $0.value.id, name: $0.value.name, arguments: $0.value.arguments)
                }
            }
        }

        return ChatStreamChunk(
            id: id,
            content: content,
            reasoningContent: reasoningContent,
            toolCalls: toolCalls,
            finishReason: finishReason,
            usage: usage
        )
    }

    private func parseUsage(_ usage: [String: Any]?) -> UsageInfo? {
        guard let usage = usage else { return nil }
        return UsageInfo(
            promptTokens: usage["prompt_tokens"] as? Int,
            completionTokens: usage["completion_tokens"] as? Int,
            totalTokens: usage["total_tokens"] as? Int
        )
    }

    private func encodeSchemaToDict(_ schema: JSONSchema) -> [String: Any] {
        var dict: [String: Any] = ["type": schema.type]
        if let props = schema.properties {
            var propsDict: [String: Any] = [:]
            for (key, prop) in props {
                var propDict: [String: Any] = ["type": prop.type]
                if let desc = prop.description { propDict["description"] = desc }
                if let enumVals = prop.enumValues { propDict["enum"] = enumVals }
                if let items = prop.items {
                    propDict["items"] = ["type": items.type]
                }
                propsDict[key] = propDict
            }
            dict["properties"] = propsDict
        }
        if let required = schema.required { dict["required"] = required }
        if let desc = schema.description { dict["description"] = desc }
        return dict
    }
}

// MARK: - OpenAI Response Types

private struct OpenAIModelsResponse: Decodable {
    let data: [OpenAIModel]
}

private struct OpenAIModel: Decodable {
    let id: String
}

// MARK: - Errors

enum OpenAIProviderError: Error, LocalizedError {
    case serializationFailed

    var errorDescription: String? {
        switch self {
        case .serializationFailed:
            return "Failed to serialize OpenAI API request body"
        }
    }
}
