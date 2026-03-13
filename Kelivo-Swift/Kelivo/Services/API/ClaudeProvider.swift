import Foundation

// MARK: - Claude Provider

final class ClaudeProvider: LLMProvider, @unchecked Sendable {
    let id: String
    let name: String
    let apiType: APIType = .claude

    private let baseUrl: String
    private let apiKey: String
    private let anthropicVersion: String

    init(
        id: String = "claude",
        name: String = "Claude",
        baseUrl: String,
        apiKey: String,
        anthropicVersion: String = "2023-06-01"
    ) {
        self.id = id
        self.name = name
        self.baseUrl = baseUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        self.apiKey = apiKey
        self.anthropicVersion = anthropicVersion
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
        let url = URL(string: "\(baseUrl)/v1/messages")!
        let headers = buildHeaders()

        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return AsyncThrowingStream { $0.finish(throwing: ClaudeProviderError.serializationFailed) }
        }

        let rawStream = HTTPClient.shared.stream(url, method: "POST", headers: headers, body: bodyData)
        let sseStream = SSEParser.parse(rawStream)

        return AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    for try await event in sseStream {
                        if Task.isCancelled {
                            continuation.finish()
                            return
                        }
                        if let chunk = self.parseSSEEvent(event) {
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
            "x-api-key": apiKey,
            "anthropic-version": anthropicVersion,
            "Content-Type": "application/json",
        ]

        let (data, _) = try await HTTPClient.shared.request(url, headers: headers)
        let response = try JSONDecoder().decode(ClaudeModelsResponse.self, from: data)

        return response.data.map { model in
            RemoteModel(
                id: model.id,
                displayName: model.displayName ?? model.id,
                contextWindow: model.contextWindow,
                maxOutputTokens: model.maxOutputTokens
            )
        }
    }

    // MARK: - Request Building

    private func buildHeaders() -> [String: String] {
        [
            "x-api-key": apiKey,
            "anthropic-version": anthropicVersion,
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
        ]

        // Separate system message from conversation messages
        var systemContent: [[String: Any]]?
        var conversationMessages: [[String: Any]] = []

        for message in messages {
            if message.role == "system" {
                systemContent = convertContentForClaude(message.content)
            } else {
                var msg: [String: Any] = ["role": message.role]
                msg["content"] = convertContentForClaude(message.content)
                conversationMessages.append(msg)
            }
        }

        if let system = systemContent {
            body["system"] = system
        }
        body["messages"] = conversationMessages

        if let maxTokens = parameters.maxTokens {
            body["max_tokens"] = maxTokens
        } else {
            body["max_tokens"] = 4096
        }

        if let temperature = parameters.temperature {
            body["temperature"] = temperature
        }
        if let topP = parameters.topP {
            body["top_p"] = topP
        }

        // Extended thinking (reasoning)
        if let budget = parameters.reasoningBudget, budget > 0 {
            body["thinking"] = [
                "type": "enabled",
                "budget_tokens": budget,
            ]
        }

        // Tools
        if let tools = tools, !tools.isEmpty {
            body["tools"] = tools.map { tool -> [String: Any] in
                var toolDict: [String: Any] = [
                    "name": tool.name,
                    "description": tool.description,
                ]
                toolDict["input_schema"] = encodeSchemaToDict(tool.parameters)
                return toolDict
            }
        }

        return body
    }

    private func convertContentForClaude(_ content: MessageContent) -> [[String: Any]] {
        switch content {
        case .text(let text):
            return [["type": "text", "text": text]]
        case .parts(let parts):
            return parts.map { part in
                switch part {
                case .text(let text):
                    return ["type": "text", "text": text]
                case .image(let data, let mimeType):
                    return [
                        "type": "image",
                        "source": [
                            "type": "base64",
                            "media_type": mimeType,
                            "data": data.base64EncodedString(),
                        ] as [String: Any],
                    ]
                }
            }
        }
    }

    // MARK: - SSE Parsing

    private func parseSSEEvent(_ event: SSEEvent) -> ChatStreamChunk? {
        guard let data = event.data.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return nil
        }

        let eventType = event.event ?? json["type"] as? String ?? ""

        switch eventType {
        case "message_start":
            guard let message = json["message"] as? [String: Any] else { return nil }
            let id = message["id"] as? String
            let usage = parseUsage(message["usage"] as? [String: Any])
            return ChatStreamChunk(id: id, usage: usage)

        case "content_block_start":
            guard let contentBlock = json["content_block"] as? [String: Any] else { return nil }
            let blockType = contentBlock["type"] as? String

            if blockType == "tool_use" {
                let toolId = contentBlock["id"] as? String ?? ""
                let toolName = contentBlock["name"] as? String ?? ""
                let toolCall = ToolCall(id: toolId, name: toolName, arguments: "")
                return ChatStreamChunk(toolCalls: [toolCall])
            }
            if blockType == "thinking" {
                let thinking = contentBlock["thinking"] as? String
                return ChatStreamChunk(reasoningContent: thinking)
            }
            return nil

        case "content_block_delta":
            guard let delta = json["delta"] as? [String: Any] else { return nil }
            let deltaType = delta["type"] as? String

            switch deltaType {
            case "text_delta":
                let text = delta["text"] as? String
                return ChatStreamChunk(content: text)
            case "thinking_delta":
                let thinking = delta["thinking"] as? String
                return ChatStreamChunk(reasoningContent: thinking)
            case "input_json_delta":
                let partial = delta["partial_json"] as? String ?? ""
                let toolCall = ToolCall(id: "", name: "", arguments: partial)
                return ChatStreamChunk(toolCalls: [toolCall])
            default:
                return nil
            }

        case "message_delta":
            guard let delta = json["delta"] as? [String: Any] else { return nil }
            let finishReason = delta["stop_reason"] as? String
            let usage = parseUsage(json["usage"] as? [String: Any])
            return ChatStreamChunk(finishReason: finishReason, usage: usage)

        case "message_stop":
            return ChatStreamChunk(finishReason: "stop")

        case "ping":
            return nil

        case "error":
            // Error events are handled but we still return nil to let the
            // stream infrastructure handle errors via HTTP status codes
            return nil

        default:
            return nil
        }
    }

    private func parseUsage(_ usage: [String: Any]?) -> UsageInfo? {
        guard let usage = usage else { return nil }
        return UsageInfo(
            promptTokens: usage["input_tokens"] as? Int,
            completionTokens: usage["output_tokens"] as? Int,
            totalTokens: nil
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

// MARK: - Claude Response Types

private struct ClaudeModelsResponse: Decodable {
    let data: [ClaudeModel]
}

private struct ClaudeModel: Decodable {
    let id: String
    let displayName: String?
    let contextWindow: Int?
    let maxOutputTokens: Int?

    private enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case contextWindow = "context_window"
        case maxOutputTokens = "max_output_tokens"
    }
}

// MARK: - Errors

enum ClaudeProviderError: Error, LocalizedError {
    case serializationFailed

    var errorDescription: String? {
        switch self {
        case .serializationFailed:
            return "Failed to serialize Claude API request body"
        }
    }
}
