import Foundation
import Observation

// MARK: - Supporting Types

struct JSONSchema: Codable, Sendable {
    let type: String?
    let properties: [String: JSONSchema]?
    let required: [String]?
    let description: String?
    let items: JSONSchema?

    init(
        type: String? = nil,
        properties: [String: JSONSchema]? = nil,
        required: [String]? = nil,
        description: String? = nil,
        items: JSONSchema? = nil
    ) {
        self.type = type
        self.properties = properties
        self.required = required
        self.description = description
        self.items = items
    }
}

// MARK: - MCPViewModel

@Observable
final class MCPViewModel {

    // MARK: - Nested Types

    struct MCPServerConfig: Identifiable, Codable, Sendable {
        var id: String
        var name: String
        var command: String
        var args: [String]
        var env: [String: String]
        var isEnabled: Bool
        var transportType: TransportType
        var sseUrl: String?

        enum TransportType: String, Codable, Sendable {
            case stdio
            case sse
        }

        init(
            id: String = UUID().uuidString,
            name: String,
            command: String = "",
            args: [String] = [],
            env: [String: String] = [:],
            isEnabled: Bool = true,
            transportType: TransportType = .stdio,
            sseUrl: String? = nil
        ) {
            self.id = id
            self.name = name
            self.command = command
            self.args = args
            self.env = env
            self.isEnabled = isEnabled
            self.transportType = transportType
            self.sseUrl = sseUrl
        }
    }

    struct MCPTool: Identifiable, Codable, Sendable {
        var name: String
        var description: String
        var inputSchema: JSONSchema

        var id: String { name }
    }

    // MARK: Published State

    var servers: [MCPServerConfig] = []
    var connectedServers: Set<String> = []
    var availableTools: [String: [MCPTool]] = [:]

    // MARK: - Persistence Key

    private static let storageKey = "mcp.servers"

    // MARK: - Server Management

    func loadServers() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([MCPServerConfig].self, from: data)
        else { return }

        servers = decoded
    }

    func addServer(_ config: MCPServerConfig) {
        servers.append(config)
        persistServers()
    }

    func removeServer(_ id: String) {
        disconnect(serverId: id)
        servers.removeAll { $0.id == id }
        availableTools.removeValue(forKey: id)
        persistServers()
    }

    // MARK: - Connection

    func connect(serverId: String) async throws {
        guard let server = servers.first(where: { $0.id == serverId }) else { return }

        switch server.transportType {
        case .stdio:
            // TODO: Launch subprocess with server.command and server.args,
            // set up JSON-RPC stdio communication, perform initialize handshake
            break
        case .sse:
            // TODO: Connect to server.sseUrl via SSE transport,
            // perform initialize handshake
            break
        }

        connectedServers.insert(serverId)
        try await refreshTools(serverId: serverId)
    }

    func disconnect(serverId: String) {
        // TODO: Send shutdown notification and close transport connection
        connectedServers.remove(serverId)
        availableTools.removeValue(forKey: serverId)
    }

    // MARK: - Tools

    func refreshTools(serverId: String) async throws {
        guard connectedServers.contains(serverId) else { return }

        // TODO: Send tools/list JSON-RPC request to the connected server
        // Parse response and populate availableTools[serverId]
        availableTools[serverId] = []
    }

    func callTool(
        serverId: String,
        toolName: String,
        arguments: [String: Any]
    ) async throws -> String {
        guard connectedServers.contains(serverId) else {
            throw MCPError.serverNotConnected(serverId)
        }

        // TODO: Send tools/call JSON-RPC request with toolName and arguments
        // Parse and return the result content
        _ = toolName
        _ = arguments
        return ""
    }

    // MARK: - Errors

    enum MCPError: LocalizedError {
        case serverNotConnected(String)
        case toolCallFailed(String)

        var errorDescription: String? {
            switch self {
            case .serverNotConnected(let id):
                return "MCP server '\(id)' is not connected."
            case .toolCallFailed(let reason):
                return "Tool call failed: \(reason)"
            }
        }
    }

    // MARK: - Private

    private func persistServers() {
        guard let data = try? JSONEncoder().encode(servers) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }
}
