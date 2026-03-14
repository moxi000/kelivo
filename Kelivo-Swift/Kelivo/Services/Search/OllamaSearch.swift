import Foundation

/// Search provider using the Ollama web search API.
struct OllamaSearch: SearchProvider {
    let id = "ollama"
    let name = "Ollama"

    private let apiKey: String
    private let endpoint = "https://ollama.com/api/web_search"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("Ollama API key is not set")
        }

        guard let url = URL(string: endpoint) else {
            throw SearchError.invalidConfiguration("Invalid Ollama endpoint")
        }

        let requestBody: [String: Any] = [
            "query": query,
            "max_results": min(maxResults, 10),
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

        guard let results = json?["results"] as? [[String: Any]] else {
            return []
        }

        return results.compactMap { item -> SearchResult? in
            guard let title = item["title"] as? String,
                  let url = item["url"] as? String
            else { return nil }

            let content = item["content"] as? String ?? ""

            return SearchResult(
                title: title,
                url: url,
                snippet: content,
                content: nil
            )
        }
    }
}
