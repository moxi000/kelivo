import Foundation

// MARK: - Tool Handler Error

enum ToolHandlerError: Error, LocalizedError {
    case unknownTool(String)
    case invalidArguments(tool: String, detail: String)
    case executionFailed(tool: String, underlying: Error)

    var errorDescription: String? {
        switch self {
        case let .unknownTool(name):
            return "Unknown tool: '\(name)'"
        case let .invalidArguments(tool, detail):
            return "Invalid arguments for tool '\(tool)': \(detail)"
        case let .executionFailed(tool, underlying):
            return "Tool '\(tool)' execution failed: \(underlying.localizedDescription)"
        }
    }
}

// MARK: - Tool Handler Service

/// Routes tool calls from LLM responses to the appropriate handler and
/// formats results for sending back to the model.
///
/// Supported handler categories:
/// - **Built-in tools**: web search, URL fetch, code execution, image generation.
/// - **MCP tools**: Tools from connected MCP servers, identified by composite
///   IDs (`serverId:toolName`).
actor ToolHandlerService {
    private let mcpService: MCPToolService
    private let searchService: SearchServiceManager

    init(
        mcpService: MCPToolService = .shared,
        searchService: SearchServiceManager = .shared
    ) {
        self.mcpService = mcpService
        self.searchService = searchService
    }

    // MARK: - Handle Tool Call

    /// Execute a tool call by name with the given arguments.
    ///
    /// The method first checks built-in tools, then falls back to MCP tools
    /// (using the composite `serverId:toolName` format).
    ///
    /// - Parameters:
    ///   - name: The tool name as returned by the LLM.
    ///   - arguments: Either a JSON string or a pre-parsed dictionary.
    /// - Returns: A string result to send back to the LLM.
    func handleToolCall(name: String, arguments: [String: Any]) async throws -> String {
        // Built-in tools
        switch name {
        case "web_search":
            return try await handleWebSearch(arguments: arguments)

        case "url_fetch":
            return try await handleURLFetch(arguments: arguments)

        case "code_execution":
            return handleCodeExecution(arguments: arguments)

        case "image_generation":
            return handleImageGeneration(arguments: arguments)

        default:
            // Try MCP tool (composite ID format: serverId:toolName)
            if name.contains(":") {
                return try await handleMCPTool(compositeId: name, arguments: arguments)
            }

            throw ToolHandlerError.unknownTool(name)
        }
    }

    /// Convenience overload that parses a JSON arguments string.
    func handleToolCall(name: String, argumentsJSON: String) async throws -> String {
        let arguments = parseArguments(argumentsJSON)
        return try await handleToolCall(name: name, arguments: arguments)
    }

    // MARK: - Process Streaming Tool Calls

    /// Process a batch of tool calls from a streaming response and return
    /// formatted results.
    func processToolCalls(_ toolCalls: [ToolCall]) async -> [ToolResult] {
        var results: [ToolResult] = []

        for toolCall in toolCalls {
            do {
                let arguments = parseArguments(toolCall.arguments)
                let output = try await handleToolCall(name: toolCall.name, arguments: arguments)
                results.append(ToolResult(toolCallId: toolCall.id, content: output))
            } catch {
                results.append(ToolResult(
                    toolCallId: toolCall.id,
                    content: "Tool '\(toolCall.name)' failed: \(error.localizedDescription)",
                    isError: true
                ))
            }
        }

        return results
    }

    // MARK: - Built-in Tool Handlers

    private func handleWebSearch(arguments: [String: Any]) async throws -> String {
        guard let query = arguments["query"] as? String, !query.isEmpty else {
            throw ToolHandlerError.invalidArguments(tool: "web_search", detail: "Missing 'query' parameter")
        }

        let maxResults = (arguments["num_results"] as? Int) ?? 5

        do {
            let results = try await searchService.search(query: query, maxResults: maxResults)

            if results.isEmpty {
                return "No search results found for: \(query)"
            }

            var output: [String] = []
            for (index, result) in results.enumerated() {
                output.append("[\(index + 1)] \(result.title)")
                output.append("URL: \(result.url)")
                if !result.snippet.isEmpty {
                    output.append(result.snippet)
                }
                if let content = result.content, !content.isEmpty {
                    output.append(content)
                }
                output.append("")
            }
            return output.joined(separator: "\n")
        } catch {
            throw ToolHandlerError.executionFailed(tool: "web_search", underlying: error)
        }
    }

    private func handleURLFetch(arguments: [String: Any]) async throws -> String {
        guard let urlString = arguments["url"] as? String,
              let url = URL(string: urlString)
        else {
            throw ToolHandlerError.invalidArguments(tool: "url_fetch", detail: "Missing or invalid 'url' parameter")
        }

        do {
            let (data, _) = try await HTTPClient.shared.request(url)
            return String(data: data, encoding: .utf8) ?? "[Binary content, \(data.count) bytes]"
        } catch {
            throw ToolHandlerError.executionFailed(tool: "url_fetch", underlying: error)
        }
    }

    private func handleCodeExecution(arguments: [String: Any]) -> String {
        // Code execution is not supported locally for security reasons.
        let language = arguments["language"] as? String ?? "unknown"
        return "Code execution in '\(language)' is not supported in this environment. "
            + "Please execute the code manually."
    }

    private func handleImageGeneration(arguments: [String: Any]) -> String {
        // Image generation requires external API integration.
        let prompt = arguments["prompt"] as? String ?? ""
        return "Image generation is not available locally. Prompt: \(prompt)"
    }

    // MARK: - MCP Tool Handler

    private func handleMCPTool(compositeId: String, arguments: [String: Any]) async throws -> String {
        do {
            let result = try await mcpService.callTool(compositeId: compositeId, arguments: arguments)
            return formatMCPResult(result)
        } catch {
            throw ToolHandlerError.executionFailed(tool: compositeId, underlying: error)
        }
    }

    /// Format an MCP tool call result into a string for the LLM.
    private func formatMCPResult(_ result: MCPToolCallResult) -> String {
        var parts: [String] = []

        for content in result.content {
            switch content.type {
            case "text":
                if let text = content.text {
                    parts.append(text)
                }
            case "image":
                let mime = content.mimeType ?? "unknown"
                let size = content.data?.count ?? 0
                parts.append("[Image: \(mime), \(size) bytes]")
            case "resource":
                if let text = content.text {
                    parts.append(text)
                }
            default:
                if let text = content.text {
                    parts.append(text)
                }
            }
        }

        return parts.joined(separator: "\n")
    }

    // MARK: - Helpers

    /// Parse a JSON arguments string into a dictionary.
    private func parseArguments(_ jsonString: String) -> [String: Any] {
        guard !jsonString.isEmpty,
              let data = jsonString.data(using: .utf8),
              let parsed = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return [:]
        }
        return parsed
    }
}
