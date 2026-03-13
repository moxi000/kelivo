import Foundation

/// Search provider using Jina Reader API for fetching and parsing web pages.
struct JinaSearch: SearchProvider {
    let id = "jina"
    let name = "Jina Reader"

    private let apiKey: String?
    private let readerEndpoint = "https://r.jina.ai/"
    private let searchEndpoint = "https://s.jina.ai/"

    init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(searchEndpoint)\(encoded)")
        else {
            throw SearchError.invalidConfiguration("Failed to construct Jina search URL")
        }

        var headers: [String: String] = [
            "Accept": "application/json",
            "X-Return-Format": "text",
        ]
        if let apiKey, !apiKey.isEmpty {
            headers["Authorization"] = "Bearer \(apiKey)"
        }

        let (data, _) = try await HTTPClient.shared.request(
            url,
            method: "GET",
            headers: headers
        )

        return try parseResponse(data, maxResults: maxResults)
    }

    /// Fetch and parse a single URL using Jina Reader.
    func fetchPage(urlString: String) async throws -> String {
        guard let url = URL(string: "\(readerEndpoint)\(urlString)") else {
            throw SearchError.invalidConfiguration("Invalid URL: \(urlString)")
        }

        var headers: [String: String] = [
            "Accept": "text/plain",
        ]
        if let apiKey, !apiKey.isEmpty {
            headers["Authorization"] = "Bearer \(apiKey)"
        }

        let (data, _) = try await HTTPClient.shared.request(
            url,
            method: "GET",
            headers: headers
        )

        guard let text = String(data: data, encoding: .utf8) else {
            throw SearchError.parseFailed("Failed to decode Jina Reader response")
        }

        return text
    }

    // MARK: - Response Parsing

    private func parseResponse(_ data: Data, maxResults: Int) throws -> [SearchResult] {
        let json = try JSONSerialization.jsonObject(with: data)

        // Jina search returns { "data": [ { "title", "url", "content" } ] }
        if let dict = json as? [String: Any],
           let items = dict["data"] as? [[String: Any]]
        {
            return items.prefix(maxResults).compactMap { item -> SearchResult? in
                guard let title = item["title"] as? String,
                      let url = item["url"] as? String
                else { return nil }

                let description = item["description"] as? String ?? ""
                let content = item["content"] as? String

                return SearchResult(
                    title: title,
                    url: url,
                    snippet: description,
                    content: content
                )
            }
        }

        throw SearchError.parseFailed("Unexpected Jina response format")
    }
}
