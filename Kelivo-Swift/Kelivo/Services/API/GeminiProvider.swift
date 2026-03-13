import Foundation

// MARK: - Gemini Provider

/// Implements LLMProvider for the Google Gemini API.
/// Uses the `v1beta` endpoint with API key authentication via query parameter.
final class GeminiProvider: LLMProvider, @unchecked Sendable {
    let id: String
    let name: String
    let apiType: APIType = .gemini

    private let baseUrl: String
    private let apiKey: String

    init(
        id: String = "gemini",
        name: String = "Gemini",
        baseUrl: String = "https://generativelanguage.googleapis.com",
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
            messages: messages, parameters: parameters, tools: tools)
        let urlString =
            "\(baseUrl)/v1beta/models/\(model):streamGenerateContent?alt=sse&key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            return AsyncThrowingStream { $0.finish(throwing: GeminiProviderError.invalidURL) }
        }

        let headers = ["Content-Type": "application/json"]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return AsyncThrowingStream { $0.finish(throwing: GeminiProviderError.serializationFailed) }
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
                        if let chunk = self.parseStreamResponse(event) {
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
        let urlString =
            "\(baseUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/")))/v1beta/models?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw GeminiProviderError.invalidURL
        }

        let (data, _) = try await HTTPClient.shared.request(url)
        let response = try JSONDecoder().decode(GeminiModelsResponse.self, from: data)

        return response.models.compactMap { model -> RemoteModel? in
            // Filter to generative models only
            guard model.name.contains("/") else { return nil }
            let modelId = model.name.components(separatedBy: "/").last ?? model.name
            return RemoteModel(
                id: modelId,
                displayName: model.displayName ?? modelId,
                contextWindow: model.inputTokenLimit,
                maxOutputTokens: model.outputTokenLimit
            )
        }
    }

    // MARK: - Request Building

    /// Builds the Gemini API request body.
    /// This method is internal so VertexProvider can reuse it.
    func buildRequestBody(
        messages: [MessagePayload],
        parameters: ModelParameters,
        tools: [ToolDefinition]?
    ) -> [String: Any] {
        var body: [String: Any] = [:]

        // Convert messages to Gemini's contents format
        var contents: [[String: Any]] = []
        var systemInstruction: [String: Any]?

        for message in messages {
            if message.role == "system" {
                // Gemini uses systemInstruction at top level
                systemInstruction = [
                    "parts": convertPartsForGemini(message.content)
                ]
            } else {
                let role = message.role == "assistant" ? "model" : "user"
                contents.append([
                    "role": role,
                    "parts": convertPartsForGemini(message.content),
                ])
            }
        }

        body["contents"] = contents
        if let system = systemInstruction {
            body["systemInstruction"] = system
        }

        // Generation config
        var generationConfig: [String: Any] = [:]
        if let temperature = parameters.temperature {
            generationConfig["temperature"] = temperature
        }
        if let topP = parameters.topP {
            generationConfig["topP"] = topP
        }
        if let maxTokens = parameters.maxTokens {
            generationConfig["maxOutputTokens"] = maxTokens
        }
        if let frequencyPenalty = parameters.frequencyPenalty {
            generationConfig["frequencyPenalty"] = frequencyPenalty
        }
        if let presencePenalty = parameters.presencePenalty {
            generationConfig["presencePenalty"] = presencePenalty
        }
        if !generationConfig.isEmpty {
            body["generationConfig"] = generationConfig
        }

        // Tools
        if let tools = tools, !tools.isEmpty {
            let functionDeclarations = tools.map { tool -> [String: Any] in
                var funcDict: [String: Any] = [
                    "name": tool.name,
                    "description": tool.description,
                ]
                funcDict["parameters"] = encodeSchemaToDict(tool.parameters)
                return funcDict
            }
            body["tools"] = [["functionDeclarations": functionDeclarations]]
        }

        return body
    }

    private func convertPartsForGemini(_ content: MessageContent) -> [[String: Any]] {
        switch content {
        case .text(let text):
            return [["text": text]]
        case .parts(let parts):
            return parts.map { part in
                switch part {
                case .text(let text):
                    return ["text": text]
                case .image(let data, let mimeType):
                    return [
                        "inlineData": [
                            "mimeType": mimeType,
                            "data": data.base64EncodedString(),
                        ]
                    ]
                }
            }
        }
    }

    // MARK: - Stream Response Parsing

    /// Parses a Gemini SSE event into a ChatStreamChunk.
    /// This method is internal so VertexProvider can reuse it.
    func parseStreamResponse(_ event: SSEEvent) -> ChatStreamChunk? {
        guard let data = event.data.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return nil
        }

        guard let candidates = json["candidates"] as? [[String: Any]],
            let candidate = candidates.first
        else {
            // Check for usage metadata without candidates
            if let usageMetadata = json["usageMetadata"] as? [String: Any] {
                let usage = parseUsage(usageMetadata)
                return ChatStreamChunk(usage: usage)
            }
            return nil
        }

        let finishReason = candidate["finishReason"] as? String

        guard let content = candidate["content"] as? [String: Any],
            let parts = content["parts"] as? [[String: Any]]
        else {
            return ChatStreamChunk(finishReason: mapFinishReason(finishReason))
        }

        var textContent: String?
        var toolCalls: [ToolCall] = []

        for part in parts {
            if let text = part["text"] as? String {
                textContent = (textContent ?? "") + text
            }
            if let functionCall = part["functionCall"] as? [String: Any] {
                let name = functionCall["name"] as? String ?? ""
                let args = functionCall["args"] as? [String: Any] ?? [:]
                let argsString: String
                if let argsData = try? JSONSerialization.data(withJSONObject: args) {
                    argsString = String(data: argsData, encoding: .utf8) ?? "{}"
                } else {
                    argsString = "{}"
                }
                toolCalls.append(ToolCall(
                    id: UUID().uuidString,
                    name: name,
                    arguments: argsString
                ))
            }
        }

        let usage: UsageInfo?
        if let usageMetadata = json["usageMetadata"] as? [String: Any] {
            usage = parseUsage(usageMetadata)
        } else {
            usage = nil
        }

        return ChatStreamChunk(
            content: textContent,
            toolCalls: toolCalls.isEmpty ? nil : toolCalls,
            finishReason: mapFinishReason(finishReason),
            usage: usage
        )
    }

    private func parseUsage(_ metadata: [String: Any]) -> UsageInfo {
        UsageInfo(
            promptTokens: metadata["promptTokenCount"] as? Int,
            completionTokens: metadata["candidatesTokenCount"] as? Int,
            totalTokens: metadata["totalTokenCount"] as? Int
        )
    }

    private func mapFinishReason(_ reason: String?) -> String? {
        guard let reason = reason else { return nil }
        switch reason {
        case "STOP": return "stop"
        case "MAX_TOKENS": return "length"
        case "SAFETY": return "content_filter"
        case "RECITATION": return "content_filter"
        default: return reason.lowercased()
        }
    }

    private func encodeSchemaToDict(_ schema: JSONSchema) -> [String: Any] {
        var dict: [String: Any] = ["type": schema.type.uppercased()]
        if let props = schema.properties {
            var propsDict: [String: Any] = [:]
            for (key, prop) in props {
                var propDict: [String: Any] = ["type": prop.type.uppercased()]
                if let desc = prop.description { propDict["description"] = desc }
                if let enumVals = prop.enumValues { propDict["enum"] = enumVals }
                if let items = prop.items {
                    propDict["items"] = ["type": items.type.uppercased()]
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

// MARK: - Gemini Response Types

private struct GeminiModelsResponse: Decodable {
    let models: [GeminiModel]
}

private struct GeminiModel: Decodable {
    let name: String
    let displayName: String?
    let inputTokenLimit: Int?
    let outputTokenLimit: Int?
}

// MARK: - Errors

enum GeminiProviderError: Error, LocalizedError {
    case invalidURL
    case serializationFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid Gemini API URL"
        case .serializationFailed:
            return "Failed to serialize Gemini API request body"
        }
    }
}
