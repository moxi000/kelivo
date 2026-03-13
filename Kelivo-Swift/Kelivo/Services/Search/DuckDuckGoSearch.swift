import Foundation

/// Search provider using DuckDuckGo's HTML lite endpoint.
struct DuckDuckGoSearch: SearchProvider {
    let id = "duckduckgo"
    let name = "DuckDuckGo"

    private let baseURL = "https://html.duckduckgo.com/html/"

    func search(query: String, maxResults: Int) async throws -> [SearchResult] {
        guard let url = URL(string: baseURL) else {
            throw SearchError.invalidConfiguration("Invalid DuckDuckGo URL")
        }

        let bodyString = "q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        guard let bodyData = bodyString.data(using: .utf8) else {
            throw SearchError.invalidConfiguration("Failed to encode query")
        }

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
        ]

        let (data, _) = try await HTTPClient.shared.request(
            url,
            method: "POST",
            headers: headers,
            body: bodyData
        )

        guard let html = String(data: data, encoding: .utf8) else {
            throw SearchError.parseFailed("Failed to decode HTML response")
        }

        return parseHTMLResults(html, maxResults: maxResults)
    }

    // MARK: - HTML Parsing

    /// Parses DuckDuckGo HTML lite results using basic string matching.
    private func parseHTMLResults(_ html: String, maxResults: Int) -> [SearchResult] {
        var results: [SearchResult] = []

        // DuckDuckGo HTML lite uses <a class="result__a"> for links
        // and <a class="result__snippet"> for snippets
        let linkPattern = #"class="result__a"[^>]*href="([^"]*)"[^>]*>([^<]*)</a>"#
        let snippetPattern = #"class="result__snippet"[^>]*>([^<]*)</a>"#

        let linkRegex = try? NSRegularExpression(pattern: linkPattern)
        let snippetRegex = try? NSRegularExpression(pattern: snippetPattern)

        let range = NSRange(html.startIndex..., in: html)

        let linkMatches = linkRegex?.matches(in: html, range: range) ?? []
        let snippetMatches = snippetRegex?.matches(in: html, range: range) ?? []

        for i in 0..<min(linkMatches.count, maxResults) {
            let linkMatch = linkMatches[i]

            var href = ""
            var title = ""
            var snippet = ""

            if let hrefRange = Range(linkMatch.range(at: 1), in: html) {
                href = String(html[hrefRange])
                    .removingPercentEncoding ?? String(html[hrefRange])
            }
            if let titleRange = Range(linkMatch.range(at: 2), in: html) {
                title = String(html[titleRange])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if i < snippetMatches.count,
               let snippetRange = Range(snippetMatches[i].range(at: 1), in: html)
            {
                snippet = String(html[snippetRange])
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }

            // Extract actual URL from DuckDuckGo redirect
            if let uddg = URLComponents(string: href)?
                .queryItems?
                .first(where: { $0.name == "uddg" })?
                .value
            {
                href = uddg
            }

            guard !href.isEmpty, !title.isEmpty else { continue }

            results.append(SearchResult(
                title: title,
                url: href,
                snippet: snippet,
                content: nil
            ))
        }

        return results
    }
}
