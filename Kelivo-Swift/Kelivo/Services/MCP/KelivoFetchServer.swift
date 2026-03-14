import Foundation

// MARK: - Kelivo Fetch Error

enum KelivoFetchError: Error, LocalizedError {
    case invalidURL(String)
    case fetchFailed(String)
    case toolNotFound(String)

    var errorDescription: String? {
        switch self {
        case let .invalidURL(url):
            return "Invalid URL: \(url)"
        case let .fetchFailed(detail):
            return "Fetch failed: \(detail)"
        case let .toolNotFound(name):
            return "Tool not found: \(name)"
        }
    }
}

// MARK: - Fetch Request Payload

struct FetchRequestPayload: Sendable {
    let url: URL
    let headers: [String: String]

    init(url: URL, headers: [String: String] = [:]) {
        self.url = url
        self.headers = headers
    }

    /// Parse arguments from a tool call.
    static func parse(_ arguments: [String: Any]) throws -> FetchRequestPayload {
        guard let urlString = arguments["url"] as? String,
              !urlString.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            throw KelivoFetchError.invalidURL("missing or empty 'url' argument")
        }

        let trimmed = urlString.trimmingCharacters(in: .whitespaces)
        guard let url = URL(string: trimmed),
              let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https"
        else {
            throw KelivoFetchError.invalidURL(trimmed)
        }

        var headers: [String: String] = [:]
        if let rawHeaders = arguments["headers"] as? [String: Any] {
            for (key, value) in rawHeaders {
                headers[key] = "\(value)"
            }
        }

        return FetchRequestPayload(url: url, headers: headers)
    }
}

// MARK: - Kelivo Fetcher

/// Performs HTTP fetches and converts content into various formats.
enum KelivoFetcher {

    private static let defaultUserAgent =
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

    // MARK: - Fetch

    private static func fetch(_ payload: FetchRequestPayload) async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: payload.url)
        request.setValue(defaultUserAgent, forHTTPHeaderField: "User-Agent")
        for (key, value) in payload.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.timeoutInterval = 30

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw KelivoFetchError.fetchFailed("Invalid response from \(payload.url)")
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw KelivoFetchError.fetchFailed("HTTP \(httpResponse.statusCode)")
        }
        return (data, httpResponse)
    }

    /// Fetch and return raw HTML text.
    static func html(_ payload: FetchRequestPayload) async -> MCPToolCallResult {
        do {
            let (data, _) = try await fetch(payload)
            let text = String(data: data, encoding: .utf8) ?? ""
            return successResult(text)
        } catch {
            return errorResult(error.localizedDescription)
        }
    }

    /// Fetch and return plain text with HTML tags stripped.
    static func txt(_ payload: FetchRequestPayload) async -> MCPToolCallResult {
        do {
            let (data, _) = try await fetch(payload)
            let html = String(data: data, encoding: .utf8) ?? ""
            let plainText = stripHTMLTags(html)
            return successResult(plainText)
        } catch {
            return errorResult(error.localizedDescription)
        }
    }

    /// Fetch and return JSON with pretty formatting.
    static func json(_ payload: FetchRequestPayload) async -> MCPToolCallResult {
        do {
            let (data, _) = try await fetch(payload)
            // Validate and re-format as pretty JSON
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
            let text = String(data: prettyData, encoding: .utf8) ?? ""
            return successResult(text)
        } catch {
            return errorResult(error.localizedDescription)
        }
    }

    // MARK: - HTML Stripping

    /// Strip HTML tags, remove script/style content, and collapse whitespace.
    static func stripHTMLTags(_ html: String) -> String {
        var result = html

        // Remove script and style blocks
        let scriptPattern = #"<script[^>]*>[\s\S]*?</script>"#
        let stylePattern = #"<style[^>]*>[\s\S]*?</style>"#

        if let scriptRegex = try? NSRegularExpression(pattern: scriptPattern, options: .caseInsensitive) {
            result = scriptRegex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "")
        }
        if let styleRegex = try? NSRegularExpression(pattern: stylePattern, options: .caseInsensitive) {
            result = styleRegex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "")
        }

        // Remove all remaining HTML tags
        let tagPattern = #"<[^>]+>"#
        if let tagRegex = try? NSRegularExpression(pattern: tagPattern) {
            result = tagRegex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: " ")
        }

        // Decode common HTML entities
        result = result
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&nbsp;", with: " ")

        // Collapse whitespace
        if let wsRegex = try? NSRegularExpression(pattern: #"\s+"#) {
            result = wsRegex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: " ")
        }

        return result.trimmingCharacters(in: .whitespaces)
    }

    // MARK: - Result Builders

    private static func successResult(_ text: String) -> MCPToolCallResult {
        MCPToolCallResult(
            content: [MCPContent(type: "text", text: text, mimeType: nil, data: nil)],
            isError: false
        )
    }

    private static func errorResult(_ message: String) -> MCPToolCallResult {
        MCPToolCallResult(
            content: [MCPContent(type: "text", text: message, mimeType: nil, data: nil)],
            isError: true
        )
    }
}

// MARK: - Kelivo Fetch MCP Server Engine

/// Minimal in-memory MCP server that exposes fetch tools.
/// Handles JSON-RPC 2.0 messages for `initialize`, `tools/list`, and `tools/call`.
actor KelivoFetchServerEngine {
    private var isClosed = false

    // MARK: - Message Handling

    func handleMessage(_ message: [String: Any]) async -> [String: Any] {
        guard !isClosed else {
            return errorResponse(id: nil, code: -32600, message: "Server is closed")
        }

        let id = message["id"]
        let method = (message["method"] as? String) ?? ""
        let params = (message["params"] as? [String: Any]) ?? [:]

        switch method {
        case "initialize":
            return okResponse(id: id, result: [
                "serverInfo": ["name": "@kelivo/fetch", "version": "0.1.0"],
                "protocolVersion": "2024-11-05",
                "capabilities": [
                    "tools": ["listChanged": false]
                ],
            ])

        case "notifications/initialized":
            // Acknowledgment notification; no response needed.
            return noopResponse()

        case "tools/list":
            return okResponse(id: id, result: ["tools": toolDefinitions()])

        case "tools/call":
            let name = (params["name"] as? String) ?? ""
            let arguments = (params["arguments"] as? [String: Any]) ?? [:]

            let payload: FetchRequestPayload
            do {
                payload = try FetchRequestPayload.parse(arguments)
            } catch {
                let result = KelivoFetcher.stripHTMLTags(error.localizedDescription)
                return okResponse(id: id, result: [
                    "content": [["type": "text", "text": result]],
                    "isError": true,
                ])
            }

            let toolResult: MCPToolCallResult
            switch name {
            case "fetch_html":
                toolResult = await KelivoFetcher.html(payload)
            case "fetch_txt":
                toolResult = await KelivoFetcher.txt(payload)
            case "fetch_json":
                toolResult = await KelivoFetcher.json(payload)
            default:
                return errorResponse(id: id, code: -32101, message: "Tool not found: \(name)")
            }

            let contentArray: [[String: Any]] = toolResult.content.map { c in
                var dict: [String: Any] = ["type": c.type]
                if let text = c.text { dict["text"] = text }
                if let mimeType = c.mimeType { dict["mimeType"] = mimeType }
                return dict
            }
            return okResponse(id: id, result: [
                "content": contentArray,
                "isError": toolResult.isError ?? false,
            ])

        default:
            if id == nil {
                return noopResponse()
            }
            return errorResponse(id: id, code: -32601, message: "Method not found: \(method)")
        }
    }

    func close() {
        isClosed = true
    }

    // MARK: - Tool Definitions

    private func toolDefinitions() -> [[String: Any]] {
        let schema: [String: Any] = [
            "type": "object",
            "properties": [
                "url": ["type": "string", "description": "URL of the website to fetch"],
                "headers": ["type": "object", "description": "Optional headers to include in the request"],
            ],
            "required": ["url"],
        ]

        return [
            [
                "name": "fetch_html",
                "description": "Fetch a website and return the content as HTML",
                "inputSchema": schema,
            ],
            [
                "name": "fetch_txt",
                "description": "Fetch a website, return the content as plain text (no HTML)",
                "inputSchema": schema,
            ],
            [
                "name": "fetch_json",
                "description": "Fetch a JSON file from a URL",
                "inputSchema": schema,
            ],
        ]
    }

    // MARK: - JSON-RPC Helpers

    private func okResponse(id: Any?, result: [String: Any]) -> [String: Any] {
        var resp: [String: Any] = ["jsonrpc": "2.0", "result": result]
        if let id { resp["id"] = id }
        return resp
    }

    private func errorResponse(id: Any?, code: Int, message: String) -> [String: Any] {
        var resp: [String: Any] = [
            "jsonrpc": "2.0",
            "error": ["code": code, "message": message],
        ]
        if let id { resp["id"] = id }
        return resp
    }

    private func noopResponse() -> [String: Any] {
        ["jsonrpc": "2.0"]
    }
}
