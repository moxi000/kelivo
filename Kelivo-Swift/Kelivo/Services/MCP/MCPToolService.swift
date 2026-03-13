import Foundation

/// Represents a tool from an MCP server, tagged with server origin.
struct MCPTool: Sendable, Identifiable {
    let serverId: String
    let serverName: String
    let definition: MCPToolDefinition

    var id: String { "\(serverId):\(definition.name)" }
    var name: String { definition.name }
    var description: String? { definition.description }
}

/// Manages MCP server lifecycle and aggregates tools from multiple servers.
actor MCPToolService {
    static let shared = MCPToolService()

    private var clients: [String: MCPClient] = [:]
    private var configs: [String: MCPServerConfig] = [:]
    private var toolCache: [String: [MCPToolDefinition]] = [:]

    private init() {}

    // MARK: - Server Management

    /// Add a server configuration without connecting.
    func addServer(_ config: MCPServerConfig) {
        configs[config.id] = config
    }

    /// Remove a server configuration and disconnect if connected.
    func removeServer(id: String) async {
        await stopServer(id: id)
        configs.removeValue(forKey: id)
    }

    /// Start (connect to) an MCP server.
    func startServer(id: String) async throws {
        guard let config = configs[id] else {
            throw MCPClientError.connectionFailed("Server configuration '\(id)' not found")
        }

        // Disconnect existing client if any
        if let existing = clients[id] {
            await existing.disconnect()
        }

        let client = MCPClient(config: config)
        try await client.connect()
        clients[id] = client

        // Refresh tools for this server
        let tools = try await client.listTools()
        toolCache[id] = tools
    }

    /// Stop (disconnect from) an MCP server.
    func stopServer(id: String) async {
        if let client = clients.removeValue(forKey: id) {
            await client.disconnect()
        }
        toolCache.removeValue(forKey: id)
    }

    /// Check if a server is connected.
    func isServerConnected(id: String) -> Bool {
        clients[id] != nil
    }

    /// Get all server configurations.
    func allConfigs() -> [MCPServerConfig] {
        Array(configs.values)
    }

    /// Get IDs of all connected servers.
    func connectedServerIds() -> [String] {
        Array(clients.keys)
    }

    // MARK: - Tool Discovery

    /// Get all tools from all connected servers.
    func allTools() -> [MCPTool] {
        var result: [MCPTool] = []
        for (serverId, tools) in toolCache {
            let serverName = configs[serverId]?.name ?? serverId
            for tool in tools {
                result.append(MCPTool(
                    serverId: serverId,
                    serverName: serverName,
                    definition: tool
                ))
            }
        }
        return result
    }

    /// Get tools from a specific server.
    func tools(forServer serverId: String) -> [MCPToolDefinition] {
        toolCache[serverId] ?? []
    }

    /// Refresh tools from a specific server.
    func refreshTools(forServer serverId: String) async throws {
        guard let client = clients[serverId] else {
            throw MCPClientError.notConnected
        }
        let tools = try await client.listTools()
        toolCache[serverId] = tools
    }

    /// Refresh tools from all connected servers.
    func refreshAllTools() async {
        for serverId in clients.keys {
            do {
                try await refreshTools(forServer: serverId)
            } catch {
                // Log but continue with other servers
                toolCache[serverId] = []
            }
        }
    }

    // MARK: - Tool Invocation

    /// Call a tool on its originating server.
    func callTool(serverId: String, name: String, arguments: [String: Any] = [:]) async throws -> MCPToolCallResult {
        guard let client = clients[serverId] else {
            throw MCPClientError.notConnected
        }
        return try await client.callTool(name: name, arguments: arguments)
    }

    /// Call a tool using its composite ID (serverId:toolName).
    func callTool(compositeId: String, arguments: [String: Any] = [:]) async throws -> MCPToolCallResult {
        let parts = compositeId.split(separator: ":", maxSplits: 1)
        guard parts.count == 2 else {
            throw MCPClientError.invalidResponse("Invalid composite tool ID: \(compositeId)")
        }
        let serverId = String(parts[0])
        let toolName = String(parts[1])
        return try await callTool(serverId: serverId, name: toolName, arguments: arguments)
    }

    // MARK: - Resource Access

    /// List resources from a specific server.
    func listResources(serverId: String) async throws -> [MCPResource] {
        guard let client = clients[serverId] else {
            throw MCPClientError.notConnected
        }
        return try await client.listResources()
    }

    /// Read a resource from a specific server.
    func readResource(serverId: String, uri: String) async throws -> [MCPResourceContent] {
        guard let client = clients[serverId] else {
            throw MCPClientError.notConnected
        }
        return try await client.readResource(uri: uri)
    }

    // MARK: - Prompt Access

    /// List prompts from a specific server.
    func listPrompts(serverId: String) async throws -> [MCPPrompt] {
        guard let client = clients[serverId] else {
            throw MCPClientError.notConnected
        }
        return try await client.listPrompts()
    }

    /// Get a prompt from a specific server.
    func getPrompt(serverId: String, name: String, arguments: [String: String] = [:]) async throws -> [MCPPromptMessage] {
        guard let client = clients[serverId] else {
            throw MCPClientError.notConnected
        }
        return try await client.getPrompt(name: name, arguments: arguments)
    }

    // MARK: - LLM Tool Format Conversion

    /// Convert all MCP tools to a generic tool format for LLM providers.
    /// Returns an array of dictionaries matching the OpenAI function calling schema.
    func toolsAsLLMFormat() -> [[String: Any]] {
        allTools().map { tool in
            var function: [String: Any] = [
                "name": tool.id,
            ]
            if let description = tool.description {
                function["description"] = description
            }
            if let schema = tool.definition.inputSchema {
                function["parameters"] = schema.mapValues(\.value)
            } else {
                function["parameters"] = [
                    "type": "object",
                    "properties": [String: Any](),
                ]
            }
            return [
                "type": "function",
                "function": function,
            ]
        }
    }
}
