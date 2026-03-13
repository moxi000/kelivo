import Foundation

/// Search provider using the Brave Search API.
struct BraveSearch: SearchProvider {
    let id = "brave"
    let name = "Brave Search"

    private let apiKey: String
    private let endpoint = "https://api.search.brave.com/res/v1/web/search"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("Brave Search API key is not set")
        }

        var components = URLComponents(string: endpoint)!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "count", value: String(maxResults)),
        ]

        guard let url = components.url else {
            throw SearchError.invalidConfiguration("Failed to construct Brave Search URL")
        }

        let headers = [
            "Accept": "application/json",
            "Accept-Encoding": "gzip",
            "X-Subscription-Token": apiKey,
        ]

        let (data, _) = try await HTTPClient.shared.request(
            url,
            method: "GET",
            headers: headers
        )

        return try parseResponse(data)
    }

    // MARK: - Response Parsing

    private func parseResponse(_ data: Data) throws -> [SearchResult] {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let web = json?["web"] as? [String: Any],
              let results = web["results"] as? [[String: Any]]
        else {
            return []
        }

        return results.compactMap { item -> SearchResult? in
            guard let title = item["title"] as? String,
                  let url = item["url"] as? String
            else { return nil }

            let description = item["description"] as? String ?? ""
            let extraSnippets = item["extra_snippets"] as? [String]
            let content = extraSnippets?.joined(separator: "\n")

            return SearchResult(
                title: title,
                url: url,
                snippet: description,
                content: content
            )
        }
    }
}
