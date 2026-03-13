import Foundation
import Observation
import SwiftData

// MARK: - Supporting Types

struct MessagePayload {
    let role: String
    let content: String
    let images: [Data]?
}

struct ChatStreamChunk {
    let content: String?
    let reasoningContent: String?
    let isFinished: Bool
    let usage: StreamUsage?

    struct StreamUsage {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
    }
}

// MARK: - ChatViewModel

@Observable
final class ChatViewModel {

    // MARK: Published State

    var currentConversation: Conversation?
    var messages: [ChatMessage] = []
    var inputText: String = ""
    var isStreaming: Bool = false
    var streamingContent: String = ""
    var streamingReasoningContent: String = ""
    var selectedImages: [Data] = []
    var errorMessage: String?

    // MARK: Private

    private var modelContext: ModelContext?
    private var streamTask: Task<Void, Never>?

    // MARK: Configuration

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Conversation Loading

    func loadConversation(_ id: String) {
        guard let context = modelContext else { return }

        let predicate = #Predicate<Conversation> { $0.id == id }
        var descriptor = FetchDescriptor<Conversation>(predicate: predicate)
        descriptor.fetchLimit = 1

        do {
            let results = try context.fetch(descriptor)
            currentConversation = results.first

            if let conversation = currentConversation {
                loadMessages(for: conversation)
            }
        } catch {
            errorMessage = "Failed to load conversation: \(error.localizedDescription)"
        }
    }

    private func loadMessages(for conversation: Conversation) {
        guard let context = modelContext else { return }

        let messageIds = conversation.messageIds
        let predicate = #Predicate<ChatMessage> { messageIds.contains($0.id) }
        let descriptor = FetchDescriptor<ChatMessage>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )

        do {
            messages = try context.fetch(descriptor)
        } catch {
            errorMessage = "Failed to load messages: \(error.localizedDescription)"
        }
    }

    // MARK: - Send Message

    func sendMessage() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty || !selectedImages.isEmpty else { return }
        guard let context = modelContext, let conversation = currentConversation else { return }

        // Create user message
        let userMessage = ChatMessage(
            role: "user",
            content: text,
            conversationId: conversation.id
        )
        context.insert(userMessage)
        conversation.messageIds.append(userMessage.id)
        conversation.updatedAt = .now
        messages.append(userMessage)

        inputText = ""
        let imagesToSend = selectedImages
        selectedImages = []

        // Create assistant placeholder
        let assistantMessage = ChatMessage(
            role: "assistant",
            content: "",
            conversationId: conversation.id,
            isStreaming: true
        )
        context.insert(assistantMessage)
        conversation.messageIds.append(assistantMessage.id)
        messages.append(assistantMessage)

        saveContext()

        // Start streaming
        isStreaming = true
        streamingContent = ""
        streamingReasoningContent = ""
        errorMessage = nil

        streamTask = Task {
            do {
                let payloads = buildMessagePayloads()
                // TODO: Call the actual LLM API service with payloads and imagesToSend
                // The streaming loop would look like:
                // for try await chunk in apiService.streamChat(payloads) {
                //     appendStreamChunk(chunk)
                // }
                _ = payloads
                _ = imagesToSend

                // Finalize the streamed message
                saveStreamedMessage()
            } catch is CancellationError {
                // Streaming was cancelled by user
                saveStreamedMessage()
            } catch {
                await MainActor.run {
                    errorMessage = "Streaming failed: \(error.localizedDescription)"
                    saveStreamedMessage()
                }
            }

            await MainActor.run {
                isStreaming = false
                streamTask = nil
            }
        }
    }

    // MARK: - Streaming Control

    func stopStreaming() {
        streamTask?.cancel()
        streamTask = nil
        isStreaming = false
        saveStreamedMessage()
    }

    // MARK: - Message Operations

    func regenerateMessage(_ message: ChatMessage) async {
        guard let context = modelContext, let conversation = currentConversation else { return }
        guard message.role == "assistant" else { return }

        // Create a new version of the assistant message in the same group
        let newVersion = ChatMessage(
            role: "assistant",
            content: "",
            conversationId: conversation.id,
            isStreaming: true,
            groupId: message.groupId,
            version: message.version + 1
        )
        context.insert(newVersion)
        conversation.messageIds.append(newVersion.id)
        conversation.versionSelections[message.groupId ?? message.id] = newVersion.version
        messages.append(newVersion)

        saveContext()

        // Re-stream response
        isStreaming = true
        streamingContent = ""
        streamingReasoningContent = ""

        streamTask = Task {
            do {
                let payloads = buildMessagePayloads()
                // TODO: Call the actual LLM API service to regenerate
                _ = payloads
                saveStreamedMessage()
            } catch {
                await MainActor.run {
                    errorMessage = "Regeneration failed: \(error.localizedDescription)"
                    saveStreamedMessage()
                }
            }

            await MainActor.run {
                isStreaming = false
                streamTask = nil
            }
        }
    }

    func editAndResend(_ message: ChatMessage, newContent: String) async {
        guard let conversation = currentConversation else { return }
        guard message.role == "user" else { return }

        // Create a new version of the user message
        let newUserMessage = ChatMessage(
            role: "user",
            content: newContent,
            conversationId: conversation.id,
            groupId: message.groupId,
            version: message.version + 1
        )
        modelContext?.insert(newUserMessage)
        conversation.messageIds.append(newUserMessage.id)
        conversation.versionSelections[message.groupId ?? message.id] = newUserMessage.version
        messages.append(newUserMessage)

        saveContext()

        // Send the edited message as a new request
        await sendMessage()
    }

    func deleteMessage(_ message: ChatMessage) {
        guard let context = modelContext, let conversation = currentConversation else { return }

        conversation.messageIds.removeAll { $0 == message.id }
        messages.removeAll { $0.id == message.id }
        context.delete(message)
        conversation.updatedAt = .now

        saveContext()
    }

    func switchMessageVersion(_ message: ChatMessage, to version: Int) {
        guard let conversation = currentConversation else { return }

        let groupId = message.groupId ?? message.id
        conversation.versionSelections[groupId] = version

        saveContext()
    }

    func clearConversation() {
        guard let context = modelContext, let conversation = currentConversation else { return }

        for message in messages {
            context.delete(message)
        }
        messages.removeAll()
        conversation.messageIds.removeAll()
        conversation.versionSelections.removeAll()
        conversation.updatedAt = .now

        saveContext()
    }

    func translateMessage(_ message: ChatMessage) async {
        // TODO: Call translation API service
        // Set message.translation = translatedText after completion
        _ = message
    }

    // MARK: - Private Helpers

    private func buildMessagePayloads() -> [MessagePayload] {
        guard let conversation = currentConversation else { return [] }

        let versionSelections = conversation.versionSelections
        var payloads: [MessagePayload] = []

        // Build payloads from visible messages, respecting version selections
        let groupedMessages = Dictionary(grouping: messages) { $0.groupId ?? $0.id }
        var processedGroups: Set<String> = []

        for message in messages {
            let groupId = message.groupId ?? message.id
            guard !processedGroups.contains(groupId) else { continue }
            processedGroups.insert(groupId)

            // Pick the selected version for this group
            let selectedVersion = versionSelections[groupId] ?? 0
            let groupMessages = groupedMessages[groupId] ?? [message]
            let selectedMessage = groupMessages.first { $0.version == selectedVersion } ?? message

            guard !selectedMessage.content.isEmpty else { continue }

            payloads.append(MessagePayload(
                role: selectedMessage.role,
                content: selectedMessage.content,
                images: nil
            ))
        }

        return payloads
    }

    private func appendStreamChunk(_ chunk: ChatStreamChunk) {
        if let content = chunk.content {
            streamingContent += content
        }
        if let reasoning = chunk.reasoningContent {
            streamingReasoningContent += reasoning
        }

        // Update the last assistant message in-place for live display
        if let lastMessage = messages.last, lastMessage.role == "assistant" {
            lastMessage.content = streamingContent
            lastMessage.reasoningText = streamingReasoningContent.isEmpty ? nil : streamingReasoningContent
        }
    }

    private func saveStreamedMessage() {
        guard let lastMessage = messages.last, lastMessage.role == "assistant" else { return }

        lastMessage.content = streamingContent
        lastMessage.reasoningText = streamingReasoningContent.isEmpty ? nil : streamingReasoningContent
        lastMessage.isStreaming = false

        streamingContent = ""
        streamingReasoningContent = ""

        saveContext()
    }

    private func saveContext() {
        guard let context = modelContext else { return }
        do {
            try context.save()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}
