import Foundation

/// Search provider using the Bing Web Search API.
struct BingSearch: SearchProvider {
    let id = "bing"
    let name = "Bing Search"

    private let apiKey: String
    private let endpoint = "https://api.bing.microsoft.com/v7.0/search"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("Bing Search API key is not set")
        }

        var components = URLComponents(string: endpoint)!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "count", value: String(min(maxResults, 50))),
            URLQueryItem(name: "responseFilter", value: "Webpages"),
        ]

        guard let url = components.url else {
            throw SearchError.invalidConfiguration("Failed to construct Bing Search URL")
        }

        let headers = [
            "Ocp-Apim-Subscription-Key": apiKey,
            "Accept": "application/json",
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

        guard let webPages = json?["webPages"] as? [String: Any],
              let results = webPages["value"] as? [[String: Any]]
        else {
            return []
        }

        return results.compactMap { item -> SearchResult? in
            guard let name = item["name"] as? String,
                  let url = item["url"] as? String
            else { return nil }

            let snippet = item["snippet"] as? String ?? ""

            return SearchResult(
                title: name,
                url: url,
                snippet: snippet,
                content: nil
            )
        }
    }
}
