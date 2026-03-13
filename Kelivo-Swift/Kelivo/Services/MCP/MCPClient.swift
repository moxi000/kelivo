import Foundation

// MARK: - MCP Types

enum MCPTransportType: String, Sendable, Codable {
    case stdio
    case sse
}

struct MCPServerConfig: Sendable, Codable {
    let id: String
    let name: String
    let transport: MCPTransportType
    /// For stdio: the command to execute. For SSE: the URL.
    let command: String
    /// Arguments for stdio transport.
    let args: [String]
    /// Environment variables for stdio transport.
    let env: [String: String]
    /// Timeout in seconds for requests.
    let timeout: TimeInterval

    init(
        id: String = UUID().uuidString,
        name: String,
        transport: MCPTransportType = .stdio,
        command: String,
        args: [String] = [],
        env: [String: String] = [:],
        timeout: TimeInterval = 30
    ) {
        self.id = id
        self.name = name
        self.transport = transport
        self.command = command
        self.args = args
        self.env = env
        self.timeout = timeout
    }
}

// MARK: - JSON-RPC Types

struct JSONRPCRequest: Codable, Sendable {
    let jsonrpc: String
    let id: Int
    let method: String
    let params: [String: AnyCodable]?

    init(id: Int, method: String, params: [String: AnyCodable]? = nil) {
        self.jsonrpc = "2.0"
        self.id = id
        self.method = method
        self.params = params
    }
}

struct JSONRPCResponse: Codable, Sendable {
    let jsonrpc: String
    let id: Int?
    let result: AnyCodable?
    let error: JSONRPCError?
}

struct JSONRPCError: Codable, Sendable, Error, LocalizedError {
    let code: Int
    let message: String
    let data: AnyCodable?

    var errorDescription: String? {
        "MCP error \(code): \(message)"
    }
}

// MARK: - MCP Protocol Types

struct MCPCapabilities: Sendable, Codable {
    let tools: Bool?
    let resources: Bool?
    let prompts: Bool?
}

struct MCPToolDefinition: Sendable, Codable, Identifiable {
    let name: String
    let description: String?
    let inputSchema: [String: AnyCodable]?

    var id: String { name }
}

struct MCPToolCallResult: Sendable, Codable {
    let content: [MCPContent]
    let isError: Bool?
}

struct MCPContent: Sendable, Codable {
    let type: String
    let text: String?
    let mimeType: String?
    let data: String?
}

struct MCPResource: Sendable, Codable, Identifiable {
    let uri: String
    let name: String
    let description: String?
    let mimeType: String?

    var id: String { uri }
}

struct MCPResourceContent: Sendable, Codable {
    let uri: String
    let mimeType: String?
    let text: String?
    let blob: String?
}

struct MCPPrompt: Sendable, Codable, Identifiable {
    let name: String
    let description: String?
    let arguments: [MCPPromptArgument]?

    var id: String { name }
}

struct MCPPromptArgument: Sendable, Codable {
    let name: String
    let description: String?
    let required: Bool?
}

struct MCPPromptMessage: Sendable, Codable {
    let role: String
    let content: MCPContent
}

// MARK: - MCP Client Error

enum MCPClientError: Error, LocalizedError {
    case notConnected
    case connectionFailed(String)
    case timeout
    case invalidResponse(String)
    case serverError(JSONRPCError)
    case transportError(String)
    case processTerminated(Int32)

    var errorDescription: String? {
        switch self {
        case .notConnected:
            return "MCP client is not connected"
        case let .connectionFailed(detail):
            return "MCP connection failed: \(detail)"
        case .timeout:
            return "MCP request timed out"
        case let .invalidResponse(detail):
            return "Invalid MCP response: \(detail)"
        case let .serverError(error):
            return error.errorDescription
        case let .transportError(detail):
            return "MCP transport error: \(detail)"
        case let .processTerminated(code):
            return "MCP server process terminated with code \(code)"
        }
    }
}

// MARK: - MCP Client

actor MCPClient {
    let config: MCPServerConfig

    private var nextRequestId = 1
    private var isConnected = false
    private var pendingRequests: [Int: CheckedContinuation<JSONRPCResponse, Error>] = [:]

    // Stdio transport
    private var process: Process?
    private var stdinPipe: Pipe?
    private var stdoutPipe: Pipe?
    private var readTask: Task<Void, Never>?

    // SSE transport
    private var sseTask: Task<Void, Never>?
    private var sseEndpoint: String?

    // Discovered capabilities
    private(set) var serverCapabilities: MCPCapabilities?
    private(set) var serverName: String?
    private(set) var serverVersion: String?

    init(config: MCPServerConfig) {
        self.config = config
    }

    deinit {
        readTask?.cancel()
        sseTask?.cancel()
        process?.terminate()
    }

    // MARK: - Connection Lifecycle

    func connect() async throws {
        switch config.transport {
        case .stdio:
            try await connectStdio()
        case .sse:
            try await connectSSE()
        }

        // Perform MCP initialize handshake
        try await initialize()
    }

    func disconnect() {
        isConnected = false
        readTask?.cancel()
        sseTask?.cancel()

        if let process, process.isRunning {
            process.terminate()
        }
        process = nil
        stdinPipe = nil
        stdoutPipe = nil

        // Cancel all pending requests
        for (_, continuation) in pendingRequests {
            continuation.resume(throwing: MCPClientError.notConnected)
        }
        pendingRequests.removeAll()
    }

    // MARK: - Stdio Transport

    private func connectStdio() async throws {
        let proc = Process()
        proc.executableURL = URL(fileURLWithPath: config.command)
        proc.arguments = config.args

        var environment = ProcessInfo.processInfo.environment
        for (key, value) in config.env {
            environment[key] = value
        }
        proc.environment = environment

        let stdin = Pipe()
        let stdout = Pipe()
        let stderr = Pipe()

        proc.standardInput = stdin
        proc.standardOutput = stdout
        proc.standardError = stderr

        do {
            try proc.run()
        } catch {
            throw MCPClientError.connectionFailed("Failed to start process: \(error.localizedDescription)")
        }

        self.process = proc
        self.stdinPipe = stdin
        self.stdoutPipe = stdout
        self.isConnected = true

        // Start reading stdout
        readTask = Task { [weak self] in
            await self?.readStdoutLoop(stdout)
        }
    }

    private func readStdoutLoop(_ pipe: Pipe) async {
        let handle = pipe.fileHandleForReading
        var buffer = Data()

        while !Task.isCancelled {
            let data = handle.availableData
            if data.isEmpty {
                // EOF - process likely terminated
                await handleDisconnect()
                return
            }

            buffer.append(data)

            // Process complete JSON-RPC messages (newline-delimited)
            while let newlineIndex = buffer.firstIndex(of: UInt8(ascii: "\n")) {
                let messageData = buffer[buffer.startIndex..<newlineIndex]
                buffer = Data(buffer[buffer.index(after: newlineIndex)...])

                guard !messageData.isEmpty else { continue }

                do {
                    let response = try JSONDecoder().decode(JSONRPCResponse.self, from: messageData)
                    await handleResponse(response)
                } catch {
                    // Non-JSON output from server, skip
                }
            }
        }
    }

    // MARK: - SSE Transport

    private func connectSSE() async throws {
        guard let url = URL(string: config.command) else {
            throw MCPClientError.connectionFailed("Invalid SSE URL: \(config.command)")
        }

        // First, connect to the SSE endpoint to get the message endpoint
        let (data, _) = try await HTTPClient.shared.request(url, method: "GET", headers: [
            "Accept": "text/event-stream",
        ])

        // Parse the initial SSE response for the endpoint URL
        if let text = String(data: data, encoding: .utf8),
           let endpointLine = text.split(separator: "\n").first(where: { $0.hasPrefix("data:") })
        {
            let endpoint = String(endpointLine.dropFirst(5)).trimmingCharacters(in: .whitespaces)
            // Resolve relative URL
            if endpoint.hasPrefix("/") {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
                components.path = endpoint
                components.query = nil
                sseEndpoint = components.url?.absoluteString
            } else {
                sseEndpoint = endpoint
            }
        }

        isConnected = true
    }

    // MARK: - Request / Response

    private func sendRequest(method: String, params: [String: AnyCodable]? = nil) async throws -> JSONRPCResponse {
        guard isConnected else {
            throw MCPClientError.notConnected
        }

        let requestId = nextRequestId
        nextRequestId += 1

        let request = JSONRPCRequest(id: requestId, method: method, params: params)
        let data = try JSONEncoder().encode(request)

        return try await withCheckedThrowingContinuation { continuation in
            pendingRequests[requestId] = continuation

            Task {
                do {
                    switch config.transport {
                    case .stdio:
                        try await sendViaStdio(data)
                    case .sse:
                        try await sendViaSSE(data)
                    }
                } catch {
                    if let cont = pendingRequests.removeValue(forKey: requestId) {
                        cont.resume(throwing: error)
                    }
                }

                // Timeout
                try? await Task.sleep(for: .seconds(config.timeout))
                if let cont = pendingRequests.removeValue(forKey: requestId) {
                    cont.resume(throwing: MCPClientError.timeout)
                }
            }
        }
    }

    private func sendViaStdio(_ data: Data) async throws {
        guard let pipe = stdinPipe else {
            throw MCPClientError.notConnected
        }
        var payload = data
        payload.append(UInt8(ascii: "\n"))
        pipe.fileHandleForWriting.write(payload)
    }

    private func sendViaSSE(_ data: Data) async throws {
        guard let endpoint = sseEndpoint, let url = URL(string: endpoint) else {
            throw MCPClientError.transportError("SSE message endpoint not available")
        }

        let _ = try await HTTPClient.shared.request(
            url,
            method: "POST",
            headers: ["Content-Type": "application/json"],
            body: data
        )
    }

    private func handleResponse(_ response: JSONRPCResponse) {
        guard let id = response.id,
              let continuation = pendingRequests.removeValue(forKey: id)
        else { return }
        continuation.resume(returning: response)
    }

    private func handleDisconnect() {
        isConnected = false
        for (_, continuation) in pendingRequests {
            continuation.resume(throwing: MCPClientError.notConnected)
        }
        pendingRequests.removeAll()
    }

    // MARK: - MCP Protocol Methods

    private func initialize() async throws {
        let params: [String: AnyCodable] = [
            "protocolVersion": AnyCodable("2024-11-05"),
            "capabilities": AnyCodable([String: Any]()),
            "clientInfo": AnyCodable([
                "name": "Kelivo",
                "version": "1.0.0",
            ]),
        ]

        let response = try await sendRequest(method: "initialize", params: params)

        if let error = response.error {
            throw MCPClientError.serverError(error)
        }

        // Parse server info
        if let result = response.result?.value as? [String: Any] {
            if let serverInfo = result["serverInfo"] as? [String: Any] {
                serverName = serverInfo["name"] as? String
                serverVersion = serverInfo["version"] as? String
            }
        }

        // Send initialized notification (no response expected)
        let notification = JSONRPCRequest(id: nextRequestId, method: "notifications/initialized")
        nextRequestId += 1
        let data = try JSONEncoder().encode(notification)
        switch config.transport {
        case .stdio:
            try await sendViaStdio(data)
        case .sse:
            try await sendViaSSE(data)
        }
    }

    /// List available tools from the MCP server.
    func listTools() async throws -> [MCPToolDefinition] {
        let response = try await sendRequest(method: "tools/list")

        if let error = response.error {
            throw MCPClientError.serverError(error)
        }

        guard let result = response.result?.value as? [String: Any],
              let toolsArray = result["tools"] as? [[String: Any]]
        else {
            return []
        }

        let toolsData = try JSONSerialization.data(withJSONObject: toolsArray)
        return try JSONDecoder().decode([MCPToolDefinition].self, from: toolsData)
    }

    /// Call a tool on the MCP server.
    func callTool(name: String, arguments: [String: Any] = [:]) async throws -> MCPToolCallResult {
        let params: [String: AnyCodable] = [
            "name": AnyCodable(name),
            "arguments": AnyCodable(arguments),
        ]

        let response = try await sendRequest(method: "tools/call", params: params)

        if let error = response.error {
            throw MCPClientError.serverError(error)
        }

        guard let result = response.result?.value as? [String: Any] else {
            throw MCPClientError.invalidResponse("Missing result in tools/call response")
        }

        let resultData = try JSONSerialization.data(withJSONObject: result)
        return try JSONDecoder().decode(MCPToolCallResult.self, from: resultData)
    }

    /// List available resources from the MCP server.
    func listResources() async throws -> [MCPResource] {
        let response = try await sendRequest(method: "resources/list")

        if let error = response.error {
            throw MCPClientError.serverError(error)
        }

        guard let result = response.result?.value as? [String: Any],
              let resourcesArray = result["resources"] as? [[String: Any]]
        else {
            return []
        }

        let resourcesData = try JSONSerialization.data(withJSONObject: resourcesArray)
        return try JSONDecoder().decode([MCPResource].self, from: resourcesData)
    }

    /// Read a resource by URI.
    func readResource(uri: String) async throws -> [MCPResourceContent] {
        let params: [String: AnyCodable] = [
            "uri": AnyCodable(uri),
        ]

        let response = try await sendRequest(method: "resources/read", params: params)

        if let error = response.error {
            throw MCPClientError.serverError(error)
        }

        guard let result = response.result?.value as? [String: Any],
              let contentsArray = result["contents"] as? [[String: Any]]
        else {
            return []
        }

        let contentsData = try JSONSerialization.data(withJSONObject: contentsArray)
        return try JSONDecoder().decode([MCPResourceContent].self, from: contentsData)
    }

    /// List available prompts.
    func listPrompts() async throws -> [MCPPrompt] {
        let response = try await sendRequest(method: "prompts/list")

        if let error = response.error {
            throw MCPClientError.serverError(error)
        }

        guard let result = response.result?.value as? [String: Any],
              let promptsArray = result["prompts"] as? [[String: Any]]
        else {
            return []
        }

        let promptsData = try JSONSerialization.data(withJSONObject: promptsArray)
        return try JSONDecoder().decode([MCPPrompt].self, from: promptsData)
    }

    /// Get a prompt with arguments.
    func getPrompt(name: String, arguments: [String: String] = [:]) async throws -> [MCPPromptMessage] {
        let params: [String: AnyCodable] = [
            "name": AnyCodable(name),
            "arguments": AnyCodable(arguments),
        ]

        let response = try await sendRequest(method: "prompts/get", params: params)

        if let error = response.error {
            throw MCPClientError.serverError(error)
        }

        guard let result = response.result?.value as? [String: Any],
              let messagesArray = result["messages"] as? [[String: Any]]
        else {
            return []
        }

        let messagesData = try JSONSerialization.data(withJSONObject: messagesArray)
        return try JSONDecoder().decode([MCPPromptMessage].self, from: messagesData)
    }
}

// MARK: - AnyCodable

/// A type-erased Codable value for JSON-RPC parameters and results.
struct AnyCodable: Codable, Sendable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map(\.value)
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict.mapValues(\.value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is NSNull:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dict as [String: Any]:
            try container.encode(dict.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(value, .init(codingPath: [], debugDescription: "Unsupported type"))
        }
    }
}
