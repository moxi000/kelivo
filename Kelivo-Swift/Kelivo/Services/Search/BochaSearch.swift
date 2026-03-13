import Foundation

/// Search provider using the Bocha search API.
struct BochaSearch: SearchProvider {
    let id = "bocha"
    let name = "Bocha"

    private let apiKey: String
    private let endpoint: String

    init(apiKey: String, endpoint: String = "https://api.bochaai.com/v1/web-search") {
        self.apiKey = apiKey
        self.endpoint = endpoint
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("Bocha API key is not set")
        }

        guard let url = URL(string: endpoint) else {
            throw SearchError.invalidConfiguration("Invalid Bocha endpoint")
        }

        let requestBody: [String: Any] = [
            "query": query,
            "count": maxResults,
            "freshness": "noLimit",
            "summary": true,
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

        return try parseResponse(data, maxResults: maxResults)
    }

    // MARK: - Response Parsing

    private func parseResponse(_ data: Data, maxResults: Int) throws -> [SearchResult] {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        // Try standard results array format
        if let results = json?["results"] as? [[String: Any]] {
            return results.prefix(maxResults).compactMap { item -> SearchResult? in
                guard let title = item["title"] as? String,
                      let url = item["url"] as? String
                else { return nil }

                let snippet = item["snippet"] as? String
                    ?? item["summary"] as? String
                    ?? ""
                let content = item["content"] as? String

                return SearchResult(
                    title: title,
                    url: url,
                    snippet: snippet,
                    content: content
                )
            }
        }

        // Try webPages.value format (Bing-like)
        if let webPages = json?["webPages"] as? [String: Any],
           let values = webPages["value"] as? [[String: Any]]
        {
            return values.prefix(maxResults).compactMap { item -> SearchResult? in
                guard let title = item["name"] as? String ?? item["title"] as? String,
                      let url = item["url"] as? String
                else { return nil }

                let snippet = item["snippet"] as? String ?? ""

                return SearchResult(
                    title: title,
                    url: url,
                    snippet: snippet,
                    content: nil
                )
            }
        }

        return []
    }
}
