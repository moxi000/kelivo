import Foundation

/// Search provider using the Tavily search API.
struct TavilySearch: SearchProvider {
    let id = "tavily"
    let name = "Tavily"

    private let apiKey: String
    private let endpoint = "https://api.tavily.com/search"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("Tavily API key is not set")
        }

        guard let url = URL(string: endpoint) else {
            throw SearchError.invalidConfiguration("Invalid Tavily endpoint")
        }

        let requestBody: [String: Any] = [
            "api_key": apiKey,
            "query": query,
            "max_results": maxResults,
            "include_answer": false,
            "include_raw_content": true,
            "search_depth": "basic",
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: requestBody)

        let headers = [
            "Content-Type": "application/json",
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

            let snippet = item["content"] as? String ?? ""
            let rawContent = item["raw_content"] as? String

            return SearchResult(
                title: title,
                url: url,
                snippet: snippet,
                content: rawContent
            )
        }
    }
}
