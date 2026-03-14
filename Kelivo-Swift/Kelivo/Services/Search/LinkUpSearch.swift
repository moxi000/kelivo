import Foundation

/// Search provider using the LinkUp search API.
struct LinkUpSearch: SearchProvider {
    let id = "linkup"
    let name = "LinkUp"

    private let apiKey: String
    private let endpoint = "https://api.linkup.so/v1/search"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("LinkUp API key is not set")
        }

        guard let url = URL(string: endpoint) else {
            throw SearchError.invalidConfiguration("Invalid LinkUp endpoint")
        }

        let requestBody: [String: Any] = [
            "q": query,
            "depth": "standard",
            "outputType": "sourcedAnswer",
            "includeImages": "false",
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

        let answer = json?["answer"] as? String

        guard let sources = json?["sources"] as? [[String: Any]] else {
            return []
        }

        return sources.compactMap { item -> SearchResult? in
            guard let name = item["name"] as? String,
                  let url = item["url"] as? String
            else { return nil }

            let snippet = item["snippet"] as? String ?? ""

            return SearchResult(
                title: name,
                url: url,
                snippet: snippet,
                content: answer
            )
        }
    }
}
