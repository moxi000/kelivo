import Foundation

// MARK: - Search Tool Service

/// Wraps search providers as callable LLM tools and formats results for tool responses.
struct SearchToolService: Sendable {

    static let toolName = "web_search"
    static let toolDescription = "Search the web for current information. Use this when you need to find up-to-date information."

    // MARK: - Tool Definition

    /// Returns the tool definition for sending to LLM providers.
    static var toolDefinition: ToolDefinition {
        ToolDefinition(
            name: toolName,
            description: toolDescription,
            parameters: JSONSchema(
                type: "object",
                properties: [
                    "query": JSONSchemaProperty(
                        type: "string",
                        description: "The search query to look up online"
                    ),
                ],
                required: ["query"]
            )
        )
    }

    // MARK: - Search Execution

    /// Perform a search using the active search provider and return formatted results as JSON.
    ///
    /// - Parameter query: The search query string.
    /// - Returns: A JSON string containing search results or an error.
    static func performSearch(query: String) async throws -> String {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return encodeJSON(["error": "Empty search query"])
        }

        let provider = await SearchServiceManager.shared.activeProvider()

        do {
            let results = try await provider.search(query: trimmed, maxResults: 5)

            if results.isEmpty {
                return encodeJSON(["error": "No results found"])
            }

            let items: [[String: Any]] = results.enumerated().map { index, result in
                let shortId = String(UUID().uuidString.prefix(6))
                var item: [String: Any] = [
                    "index": index + 1,
                    "id": shortId,
                    "title": result.title,
                    "url": result.url,
                    "snippet": result.snippet,
                ]
                if let content = result.content, !content.isEmpty {
                    item["content"] = content
                }
                return item
            }

            return encodeJSON(["items": items])
        } catch {
            return encodeJSON(["error": "Search failed: \(error.localizedDescription)"])
        }
    }

    // MARK: - System Prompt

    /// Returns a system prompt injection describing how to use and cite search results.
    static var systemPrompt: String {
        """
        ## web_search Tool Usage

        When the user asks questions requiring real-time information or up-to-date data, use the web_search tool.

        ### Citation Format
        - Search results include an index (result number) and id (unique identifier).
        - Citation format: `content [citation](index:id)`
        - Citations MUST immediately follow the relevant content, after punctuation. Do not defer to the end.
        - Correct: `... [citation](index:id)` or `... [citation](1:a1b2c3) [citation](2:d4e5f6)`

        ### Guidelines
        1. Use when the user asks about current events, news, data, or factual verification.
        2. Every cited fact must be followed by a `[citation](index:id)` marker.
        3. Do not cluster all citations at the end of the answer.
        """
    }

    // MARK: - Helpers

    private static func encodeJSON(_ object: [String: Any]) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: [.sortedKeys]),
              let text = String(data: data, encoding: .utf8)
        else {
            return "{\"error\":\"Failed to encode result\"}"
        }
        return text
    }
}
