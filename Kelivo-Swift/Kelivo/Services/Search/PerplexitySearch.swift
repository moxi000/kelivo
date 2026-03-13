import Foundation

/// Search provider using Perplexity's OpenAI-compatible chat API with search capabilities.
struct PerplexitySearch: SearchProvider {
    let id = "perplexity"
    let name = "Perplexity"

    private let apiKey: String
    private let model: String
    private let endpoint = "https://api.perplexity.ai/chat/completions"

    init(apiKey: String, model: String = "sonar") {
        self.apiKey = apiKey
        self.model = model
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("Perplexity API key is not set")
        }

        guard let url = URL(string: endpoint) else {
            throw SearchError.invalidConfiguration("Invalid Perplexity endpoint")
        }

        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "user", "content": query],
            ],
            "max_tokens": 1024,
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: requestBody)

        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)",
        ]

        let (data, _) = try await HTTPClient.shared.request(
            url,
            method: "POST",
            headers: headers,
            body: bodyData
        )

        return try parseResponse(data)
    }

    // MARK: - Response Parsing

    private func parseResponse(_ data: Data) throws -> [SearchResult] {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let choices = json?["choices"] as? [[String: Any]],
              let first = choices.first,
              let message = first["message"] as? [String: Any],
              let content = message["content"] as? String
        else {
            throw SearchError.parseFailed("Unexpected Perplexity response format")
        }

        // Extract citations if available
        let citations = json?["citations"] as? [String] ?? []

        // Perplexity returns a synthesized answer with citations.
        // We create a single result with the full answer and individual citation results.
        var results: [SearchResult] = []

        // Main answer result
        results.append(SearchResult(
            title: "Perplexity Answer",
            url: "",
            snippet: String(content.prefix(300)),
            content: content
        ))

        // Individual citation results
        for (index, citation) in citations.enumerated() {
            results.append(SearchResult(
                title: "Citation \(index + 1)",
                url: citation,
                snippet: "",
                content: nil
            ))
        }

        return results
    }
}
