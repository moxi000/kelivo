import Foundation
import SwiftData

// MARK: - Chat Stream Update

enum ChatStreamUpdate: Sendable {
    case contentDelta(String)
    case reasoningDelta(String)
    case toolCallStart(ToolCall)
    case toolCallResult(ToolResult)
    case usage(UsageInfo)
    case finished(finishReason: String?)
    case error(Error)
}

// MARK: - Tool Result

struct ToolResult: Sendable {
    let toolCallId: String
    let content: String
    let isError: Bool

    init(toolCallId: String, content: String, isError: Bool = false) {
        self.toolCallId = toolCallId
        self.content = content
        self.isError = isError
    }
}

// MARK: - Send Message Config

struct SendMessageConfig: Sendable {
    let messages: [SendableMessage]
    let conversationId: String
    let providerApiType: APIType
    let providerBaseUrl: String
    let modelId: String
    let apiKey: String
    let parameters: ModelParameters
    let systemPrompt: String?
    let tools: [ToolDefinition]?
    let searchResults: [SearchResult]?
    let worldBookEntries: [SendableWorldBookEntry]?
    let instructionInjections: [SendableInjection]?
    let truncateIndex: Int

    init(
        messages: [SendableMessage],
        conversationId: String,
        providerApiType: APIType,
        providerBaseUrl: String,
        modelId: String,
        apiKey: String,
        parameters: ModelParameters,
        systemPrompt: String? = nil,
        tools: [ToolDefinition]? = nil,
        searchResults: [SearchResult]? = nil,
        worldBookEntries: [SendableWorldBookEntry]? = nil,
        instructionInjections: [SendableInjection]? = nil,
        truncateIndex: Int = -1
    ) {
        self.messages = messages
        self.conversationId = conversationId
        self.providerApiType = providerApiType
        self.providerBaseUrl = providerBaseUrl
        self.modelId = modelId
        self.apiKey = apiKey
        self.parameters = parameters
        self.systemPrompt = systemPrompt
        self.tools = tools
        self.searchResults = searchResults
        self.worldBookEntries = worldBookEntries
        self.instructionInjections = instructionInjections
        self.truncateIndex = truncateIndex
    }
}

// MARK: - Sendable Snapshots for SwiftData Models

/// A Sendable snapshot of a ChatMessage for crossing concurrency boundaries.
struct SendableMessage: Sendable {
    let id: String
    let role: String
    let content: String
    let groupId: String?
    let version: Int
    let timestamp: Date
}

/// A Sendable snapshot of a WorldBookEntry for crossing concurrency boundaries.
struct SendableWorldBookEntry: Sendable {
    let id: String
    let name: String
    let isEnabled: Bool
    let priority: Int
    let position: String  // raw value of WorldBookInjectionPosition
    let content: String
    let injectDepth: Int
    let role: String  // raw value of WorldBookInjectionRole
    let keywords: [String]
    let useRegex: Bool
    let caseSensitive: Bool
    let scanDepth: Int
    let constantActive: Bool
}

/// A Sendable snapshot of an InstructionInjection for crossing concurrency boundaries.
struct SendableInjection: Sendable {
    let id: String
    let name: String
    let content: String
    let isEnabled: Bool
    let groupId: String
    let sortOrder: Int
}

// MARK: - Chat Service

actor ChatService {
    private var activeTask: Task<Void, Never>?
    private var currentStreamContent = ""
    private var currentReasoningContent = ""

    /// Send a message and stream the response.
    ///
    /// The returned stream emits `ChatStreamUpdate` values as the LLM produces
    /// output. The caller is responsible for persisting messages and updating UI.
    func sendMessage(config: SendMessageConfig) -> AsyncThrowingStream<ChatStreamUpdate, Error> {
        // Cancel any in-flight streaming for this actor.
        activeTask?.cancel()
        currentStreamContent = ""
        currentReasoningContent = ""

        return AsyncThrowingStream { [weak self] continuation in
            let task = Task { [weak self] in
                guard let self else {
                    continuation.finish()
                    return
                }
                do {
                    // 1. Build message payloads from chat history
                    let payloads = await self.buildMessagePayloads(
                        messages: config.messages,
                        systemPrompt: config.systemPrompt,
                        injections: config.instructionInjections,
                        worldBookEntries: config.worldBookEntries,
                        searchResults: config.searchResults,
                        truncateIndex: config.truncateIndex
                    )

                    // 2. Create LLM provider instance based on apiType
                    let provider = self.createProvider(
                        apiType: config.providerApiType,
                        baseUrl: config.providerBaseUrl,
                        apiKey: config.apiKey
                    )

                    // 3. Stream response chunks from the provider
                    let stream = provider.sendMessage(
                        messages: payloads,
                        model: config.modelId,
                        parameters: config.parameters,
                        tools: config.tools
                    )

                    var accumulatedToolCalls: [String: AccumulatingToolCall] = [:]

                    for try await chunk in stream {
                        if Task.isCancelled {
                            continuation.yield(.finished(finishReason: "cancelled"))
                            continuation.finish()
                            return
                        }

                        // Content delta
                        if let content = chunk.content {
                            await self.appendStreamContent(content)
                            continuation.yield(.contentDelta(content))
                        }

                        // Reasoning delta
                        if let reasoning = chunk.reasoningContent {
                            await self.appendReasoningContent(reasoning)
                            continuation.yield(.reasoningDelta(reasoning))
                        }

                        // Tool calls
                        if let toolCalls = chunk.toolCalls {
                            for toolCall in toolCalls {
                                if !toolCall.name.isEmpty {
                                    // Start of a new tool call
                                    accumulatedToolCalls[toolCall.id] = AccumulatingToolCall(
                                        id: toolCall.id,
                                        name: toolCall.name,
                                        argumentsBuffer: toolCall.arguments
                                    )
                                    continuation.yield(.toolCallStart(toolCall))
                                } else if !toolCall.arguments.isEmpty {
                                    // Incremental arguments delta — find by non-empty id or last entry
                                    let key = toolCall.id.isEmpty
                                        ? (accumulatedToolCalls.keys.sorted().last ?? "")
                                        : toolCall.id
                                    accumulatedToolCalls[key]?.argumentsBuffer += toolCall.arguments
                                }
                            }
                        }

                        // Usage
                        if let usage = chunk.usage {
                            continuation.yield(.usage(usage))
                        }

                        // Finish reason
                        if let finishReason = chunk.finishReason {
                            continuation.yield(.finished(finishReason: finishReason))
                        }
                    }

                    continuation.finish()
                } catch {
                    if Task.isCancelled {
                        continuation.yield(.finished(finishReason: "cancelled"))
                        continuation.finish()
                    } else {
                        continuation.yield(.error(error))
                        continuation.finish(throwing: error)
                    }
                }
            }

            self.activeTask = task
            continuation.onTermination = { @Sendable _ in task.cancel() }
        }
    }

    /// Stop the current streaming session.
    func stopStreaming() {
        activeTask?.cancel()
        activeTask = nil
    }

    /// Regenerate the last assistant message.
    ///
    /// This removes the last assistant message from the input array and re-sends
    /// the conversation to the LLM. The caller should handle creating a new
    /// message version and persisting the result.
    func regenerate(config: SendMessageConfig) -> AsyncThrowingStream<ChatStreamUpdate, Error> {
        // Strip trailing assistant messages so the LLM generates a fresh response.
        var trimmedMessages = config.messages
        while let last = trimmedMessages.last, last.role == "assistant" {
            trimmedMessages.removeLast()
        }

        let regenerateConfig = SendMessageConfig(
            messages: trimmedMessages,
            conversationId: config.conversationId,
            providerApiType: config.providerApiType,
            providerBaseUrl: config.providerBaseUrl,
            modelId: config.modelId,
            apiKey: config.apiKey,
            parameters: config.parameters,
            systemPrompt: config.systemPrompt,
            tools: config.tools,
            searchResults: config.searchResults,
            worldBookEntries: config.worldBookEntries,
            instructionInjections: config.instructionInjections,
            truncateIndex: config.truncateIndex
        )

        return sendMessage(config: regenerateConfig)
    }

    /// Process tool calls received from the LLM response.
    ///
    /// Executes each tool call and collects the results. Tool execution is
    /// delegated to `MCPToolService` when available; otherwise returns an error
    /// result indicating the tool is unavailable.
    func processToolCalls(
        _ toolCalls: [ToolCall],
        mcpService: (any MCPToolServiceProtocol)?
    ) async -> [ToolResult] {
        var results: [ToolResult] = []

        for toolCall in toolCalls {
            do {
                if let mcpService {
                    let output = try await mcpService.executeTool(
                        name: toolCall.name,
                        arguments: toolCall.arguments
                    )
                    results.append(ToolResult(
                        toolCallId: toolCall.id,
                        content: output
                    ))
                } else {
                    results.append(ToolResult(
                        toolCallId: toolCall.id,
                        content: "Tool '\(toolCall.name)' is not available: no MCP service configured.",
                        isError: true
                    ))
                }
            } catch {
                results.append(ToolResult(
                    toolCallId: toolCall.id,
                    content: "Tool execution failed: \(error.localizedDescription)",
                    isError: true
                ))
            }
        }

        return results
    }

    // MARK: - Message Payload Building

    /// Build the full message payload array including system prompt, injections, and context.
    func buildMessagePayloads(
        messages: [SendableMessage],
        systemPrompt: String?,
        injections: [SendableInjection]?,
        worldBookEntries: [SendableWorldBookEntry]?,
        searchResults: [SearchResult]?,
        truncateIndex: Int
    ) -> [MessagePayload] {
        var payloads: [MessagePayload] = []

        // 1. System prompt with before-injections and world book entries
        var systemParts: [String] = []

        // Before-injections (sorted by sortOrder)
        if let injections {
            let beforeInjections = injections
                .filter { $0.isEnabled && $0.groupId == "before" }
                .sorted { $0.sortOrder < $1.sortOrder }
            for injection in beforeInjections {
                systemParts.append(injection.content)
            }
        }

        // Base system prompt
        if let systemPrompt, !systemPrompt.isEmpty {
            systemParts.append(systemPrompt)
        }

        // World book entries that are constant-active or keyword-matched
        if let worldBookEntries {
            let matchedEntries = matchWorldBookEntries(
                worldBookEntries,
                against: messages
            )
            let sorted = matchedEntries.sorted { $0.priority > $1.priority }
            for entry in sorted {
                if entry.position == WorldBookInjectionPosition.beforeSystemPrompt.rawValue {
                    systemParts.insert(entry.content, at: 0)
                } else if entry.position == WorldBookInjectionPosition.afterSystemPrompt.rawValue {
                    systemParts.append(entry.content)
                }
            }
        }

        // After-injections
        if let injections {
            let afterInjections = injections
                .filter { $0.isEnabled && $0.groupId == "after" }
                .sorted { $0.sortOrder < $1.sortOrder }
            for injection in afterInjections {
                systemParts.append(injection.content)
            }
        }

        // Search results context
        if let searchResults, !searchResults.isEmpty {
            let searchContext = PromptTransformer.buildSearchContext(searchResults)
            systemParts.append(searchContext)
        }

        if !systemParts.isEmpty {
            let combined = systemParts.joined(separator: "\n\n")
            payloads.append(MessagePayload(role: "system", content: .text(combined)))
        }

        // 2. Conversation messages, applying truncation if set
        let startIndex: Int
        if truncateIndex > 0 && truncateIndex <= messages.count {
            startIndex = truncateIndex
        } else {
            startIndex = 0
        }

        let activeMessages = Array(messages[startIndex...])

        // World book entries injected at topOfChat
        if let worldBookEntries {
            let topEntries = matchWorldBookEntries(worldBookEntries, against: messages)
                .filter { $0.position == WorldBookInjectionPosition.topOfChat.rawValue }
                .sorted { $0.priority > $1.priority }
            for entry in topEntries {
                payloads.append(MessagePayload(
                    role: entry.role == WorldBookInjectionRole.assistant.rawValue ? "assistant" : "user",
                    content: .text(entry.content)
                ))
            }
        }

        for message in activeMessages {
            guard !message.content.isEmpty else { continue }
            payloads.append(MessagePayload(
                role: message.role,
                content: .text(message.content)
            ))
        }

        // World book entries injected at bottomOfChat
        if let worldBookEntries {
            let bottomEntries = matchWorldBookEntries(worldBookEntries, against: messages)
                .filter { $0.position == WorldBookInjectionPosition.bottomOfChat.rawValue }
                .sorted { $0.priority > $1.priority }
            for entry in bottomEntries {
                payloads.append(MessagePayload(
                    role: entry.role == WorldBookInjectionRole.assistant.rawValue ? "assistant" : "user",
                    content: .text(entry.content)
                ))
            }
        }

        return payloads
    }

    // MARK: - Private Helpers

    /// Accumulator for tool call arguments that arrive in chunks.
    private struct AccumulatingToolCall {
        let id: String
        let name: String
        var argumentsBuffer: String
    }

    private func appendStreamContent(_ content: String) {
        currentStreamContent += content
    }

    private func appendReasoningContent(_ content: String) {
        currentReasoningContent += content
    }

    /// Create an LLM provider instance for the given API type.
    private func createProvider(
        apiType: APIType,
        baseUrl: String,
        apiKey: String
    ) -> any LLMProvider {
        switch apiType {
        case .claude:
            return ClaudeProvider(baseUrl: baseUrl, apiKey: apiKey)
        case .openaiChatCompletions, .openaiResponses, .gemini, .vertex:
            // TODO: Create specific providers for each API type as they are implemented.
            // For now, fall back to a placeholder that will fail with a clear message.
            return ClaudeProvider(
                name: "Unsupported(\(apiType.rawValue))",
                baseUrl: baseUrl,
                apiKey: apiKey
            )
        }
    }

    /// Match world book entries against conversation messages.
    ///
    /// Returns entries that are either constant-active or whose keywords appear
    /// in recent messages (within the entry's scanDepth).
    private func matchWorldBookEntries(
        _ entries: [SendableWorldBookEntry],
        against messages: [SendableMessage]
    ) -> [SendableWorldBookEntry] {
        var matched: [SendableWorldBookEntry] = []

        for entry in entries {
            guard entry.isEnabled else { continue }

            // Constant-active entries always match
            if entry.constantActive {
                matched.append(entry)
                continue
            }

            // Check keywords against recent messages within scan depth
            let scanRange = messages.suffix(entry.scanDepth)
            let combinedText = scanRange.map(\.content).joined(separator: " ")

            let keywordMatched = entry.keywords.contains { keyword in
                guard !keyword.isEmpty else { return false }

                if entry.useRegex {
                    let options: NSRegularExpression.Options = entry.caseSensitive ? [] : [.caseInsensitive]
                    guard let regex = try? NSRegularExpression(pattern: keyword, options: options) else {
                        return false
                    }
                    let range = NSRange(combinedText.startIndex..., in: combinedText)
                    return regex.firstMatch(in: combinedText, range: range) != nil
                } else {
                    if entry.caseSensitive {
                        return combinedText.contains(keyword)
                    } else {
                        return combinedText.localizedCaseInsensitiveContains(keyword)
                    }
                }
            }

            if keywordMatched {
                matched.append(entry)
            }
        }

        return matched
    }
}

// MARK: - MCP Tool Service Protocol

/// Protocol for tool execution services (MCP or builtin).
/// The concrete implementation lives in the MCP service layer.
protocol MCPToolServiceProtocol: Sendable {
    func executeTool(name: String, arguments: String) async throws -> String
}
