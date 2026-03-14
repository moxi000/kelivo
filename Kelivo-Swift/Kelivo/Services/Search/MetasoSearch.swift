import Foundation

/// Search provider using the Metaso (秘塔) search API.
struct MetasoSearch: SearchProvider {
    let id = "metaso"
    let name = "Metaso"

    private let apiKey: String
    private let endpoint = "https://metaso.cn/api/v1/search"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("Metaso API key is not set")
        }

        guard let url = URL(string: endpoint) else {
            throw SearchError.invalidConfiguration("Invalid Metaso endpoint")
        }

        let requestBody: [String: Any] = [
            "q": query,
            "scope": "webpage",
            "size": maxResults,
            "includeSummary": false,
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: requestBody)

        let headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
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

        guard let webpages = json?["webpages"] as? [[String: Any]] else {
            return []
        }

        return webpages.compactMap { item -> SearchResult? in
            guard let title = item["title"] as? String,
                  let link = item["link"] as? String
            else { return nil }

            let snippet = item["snippet"] as? String ?? ""

            return SearchResult(
                title: title,
                url: link,
                snippet: snippet,
                content: nil
            )
        }
    }
}
