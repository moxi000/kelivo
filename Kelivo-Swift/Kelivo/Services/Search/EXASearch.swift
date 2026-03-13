import Foundation

/// Search provider using the EXA search API.
struct EXASearch: SearchProvider {
    let id = "exa"
    let name = "EXA Search"

    private let apiKey: String
    private let endpoint = "https://api.exa.ai/search"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("EXA API key is not set")
        }

        guard let url = URL(string: endpoint) else {
            throw SearchError.invalidConfiguration("Invalid EXA endpoint")
        }

        let requestBody: [String: Any] = [
            "query": query,
            "num_results": maxResults,
            "type": "neural",
            "contents": [
                "text": true,
                "highlights": true,
            ],
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: requestBody)

        let headers = [
            "Content-Type": "application/json",
            "x-api-key": apiKey,
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

            let highlights = item["highlights"] as? [String]
            let snippet = highlights?.first ?? ""
            let text = item["text"] as? String

            return SearchResult(
                title: title,
                url: url,
                snippet: snippet,
                content: text
            )
        }
    }
}
