import Foundation

// MARK: - Vertex AI Provider

/// Implements LLMProvider for Google Vertex AI.
/// Reuses GeminiProvider's request/response format with Vertex-specific endpoint and OAuth2 auth.
final class VertexProvider: LLMProvider, @unchecked Sendable {
    let id: String
    let name: String
    let apiType: APIType = .vertex

    private let projectId: String
    private let region: String
    private let accessToken: String
    private let geminiProvider: GeminiProvider

    init(
        id: String = "vertex",
        name: String = "Vertex AI",
        projectId: String,
        region: String = "us-central1",
        accessToken: String
    ) {
        self.id = id
        self.name = name
        self.projectId = projectId
        self.region = region
        self.accessToken = accessToken
        // Create an internal GeminiProvider to reuse request/response format logic.
        // The baseUrl and apiKey are unused since we override the endpoint.
        self.geminiProvider = GeminiProvider(
            id: "vertex-gemini-internal",
            name: "Vertex Gemini Internal",
            baseUrl: "",
            apiKey: ""
        )
    }

    // MARK: - Send Message

    func sendMessage(
        messages: [MessagePayload],
        model: String,
        parameters: ModelParameters,
        tools: [ToolDefinition]?
    ) -> AsyncThrowingStream<ChatStreamChunk, Error> {
        let requestBody = geminiProvider.buildRequestBody(
            messages: messages, parameters: parameters, tools: tools)
        let urlString = buildEndpointURL(model: model, action: "streamGenerateContent")

        guard let url = URL(string: urlString) else {
            return AsyncThrowingStream { $0.finish(throwing: VertexProviderError.invalidURL) }
        }

        let headers = buildHeaders()

        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            return AsyncThrowingStream { $0.finish(throwing: VertexProviderError.serializationFailed) }
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
                        if let chunk = self.geminiProvider.parseStreamResponse(event) {
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
        // Vertex AI model listing uses the same region-based endpoint
        let urlString =
            "https://\(region)-aiplatform.googleapis.com/v1/projects/\(projectId)/locations/\(region)/publishers/google/models"

        guard let url = URL(string: urlString) else {
            throw VertexProviderError.invalidURL
        }

        // Use the provided apiKey as OAuth2 token for this call, falling back to the instance token
        let token = apiKey.isEmpty ? accessToken : apiKey
        let headers: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]

        let (data, _) = try await HTTPClient.shared.request(url, headers: headers)
        let response = try JSONDecoder().decode(VertexModelsResponse.self, from: data)

        return response.models.map { model in
            let modelId = model.name.components(separatedBy: "/").last ?? model.name
            return RemoteModel(
                id: modelId,
                displayName: model.displayName ?? modelId,
                contextWindow: nil,
                maxOutputTokens: nil
            )
        }
    }

    // MARK: - URL Building

    private func buildEndpointURL(model: String, action: String) -> String {
        "https://\(region)-aiplatform.googleapis.com/v1/projects/\(projectId)/locations/\(region)/publishers/google/models/\(model):\(action)?alt=sse"
    }

    private func buildHeaders() -> [String: String] {
        [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json",
        ]
    }
}

// MARK: - Vertex Response Types

private struct VertexModelsResponse: Decodable {
    let models: [VertexModel]

    private enum CodingKeys: String, CodingKey {
        case models
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        models = (try? container.decode([VertexModel].self, forKey: .models)) ?? []
    }
}

private struct VertexModel: Decodable {
    let name: String
    let displayName: String?
}

// MARK: - Errors

enum VertexProviderError: Error, LocalizedError {
    case invalidURL
    case serializationFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid Vertex AI endpoint URL"
        case .serializationFailed:
            return "Failed to serialize Vertex AI request body"
        }
    }
}
