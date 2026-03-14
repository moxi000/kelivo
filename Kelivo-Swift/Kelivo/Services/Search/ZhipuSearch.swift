import Foundation

/// Search provider using the Zhipu (智谱) web search API.
struct ZhipuSearch: SearchProvider {
    let id = "zhipu"
    let name = "Zhipu"

    private let apiKey: String
    private let endpoint = "https://open.bigmodel.cn/api/paas/v4/web_search"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard !apiKey.isEmpty else {
            throw SearchError.invalidConfiguration("Zhipu API key is not set")
        }

        guard let url = URL(string: endpoint) else {
            throw SearchError.invalidConfiguration("Invalid Zhipu endpoint")
        }

        let requestBody: [String: Any] = [
            "search_query": query,
            "search_engine": "search_std",
            "count": maxResults,
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

        guard let results = json?["search_result"] as? [[String: Any]] else {
            return []
        }

        return results.compactMap { item -> SearchResult? in
            guard let title = item["title"] as? String,
                  let link = item["link"] as? String
            else { return nil }

            let content = item["content"] as? String ?? ""

            return SearchResult(
                title: title,
                url: link,
                snippet: content,
                content: nil
            )
        }
    }
}
