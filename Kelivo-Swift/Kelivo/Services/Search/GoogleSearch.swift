import Foundation

/// Search provider using Google Custom Search API.
struct GoogleSearch: SearchProvider {
    let id = "google"
    let name = "Google Search"

    private let apiKey: String
    private let searchEngineId: String
    private let endpoint = "https://www.googleapis.com/customsearch/v1"

    init(apiKey: String, searchEngineId: String) {
        self.apiKey = apiKey
        self.searchEngineId = searchEngineId
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("Google API key is not set")
        }
        guard !searchEngineId.isEmpty else {
            throw SearchError.invalidConfiguration("Google Search Engine ID is not set")
        }

        // Google CSE supports max 10 results per request
        let num = min(maxResults, 10)

        var components = URLComponents(string: endpoint)!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "cx", value: searchEngineId),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "num", value: String(num)),
        ]

        guard let url = components.url else {
            throw SearchError.invalidConfiguration("Failed to construct Google Search URL")
        }

        let (data, _) = try await HTTPClient.shared.request(
            url,
            method: "GET",
            headers: ["Accept": "application/json"]
        )

        return try parseResponse(data)
    }

    // MARK: - Response Parsing

    private func parseResponse(_ data: Data) throws -> [SearchResult] {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let items = json?["items"] as? [[String: Any]] else {
            return []
        }

        return items.compactMap { item -> SearchResult? in
            guard let title = item["title"] as? String,
                  let link = item["link"] as? String
            else { return nil }

            let snippet = item["snippet"] as? String ?? ""

            // Extract page content from pagemap if available
            var content: String?
            if let pagemap = item["pagemap"] as? [String: Any],
               let metatags = pagemap["metatags"] as? [[String: Any]],
               let first = metatags.first
            {
                content = first["og:description"] as? String
            }

            return SearchResult(
                title: title,
                url: link,
                snippet: snippet,
                content: content
            )
        }
    }
}
