import Foundation

/// Search provider using a self-hosted SearXNG instance.
struct SearxngSearch: SearchProvider {
    let id = "searxng"
    let name = "SearXNG"

    private let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !baseURL.isEmpty else {
            throw SearchError.invalidConfiguration("SearXNG base URL is not set")
        }

        var components = URLComponents(string: "\(baseURL)/search")
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "pageno", value: "1"),
        ]

        guard let url = components?.url else {
            throw SearchError.invalidConfiguration("Failed to construct SearXNG URL")
        }

        let headers = [
            "Accept": "application/json",
        ]

        let (data, _) = try await HTTPClient.shared.request(
            url,
            method: "GET",
            headers: headers
        )

        return try parseResponse(data, maxResults: maxResults)
    }

    // MARK: - Response Parsing

    private func parseResponse(_ data: Data, maxResults: Int) throws -> [SearchResult] {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let results = json?["results"] as? [[String: Any]] else {
            return []
        }

        return results.prefix(maxResults).compactMap { item -> SearchResult? in
            guard let title = item["title"] as? String,
                  let url = item["url"] as? String
            else { return nil }

            let snippet = item["content"] as? String ?? ""

            return SearchResult(
                title: title,
                url: url,
                snippet: snippet,
                content: nil
            )
        }
    }
}
