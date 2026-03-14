import Foundation
import SwiftData

// MARK: - Message Builder Service

/// Builds API-ready message payloads from SwiftData `ChatMessage` models.
///
/// Handles:
/// - Message role mapping
/// - Image attachments → base64 content parts
/// - Document attachments → inline text content
/// - Message versioning via `groupId` and conversation `versionSelections`
/// - Context truncation via `truncateIndex`
struct MessageBuilderService {

    // MARK: - Build Messages

    /// Build an array of message payload dictionaries for a conversation.
    ///
    /// The returned array is ordered chronologically and filtered by version
    /// selection. Messages before `truncateIndex` are excluded.
    ///
    /// - Parameters:
    ///   - messages: All messages belonging to the conversation, ordered by timestamp.
    ///   - conversation: The conversation metadata (for truncation and version info).
    ///   - assistant: Optional assistant config for system prompt and template.
    /// - Returns: An array of `MessagePayload` ready for the LLM provider.
    static func buildMessages(
        from messages: [SendableMessage],
        conversation: SendableConversation,
        assistant: SendableAssistant?
    ) -> [MessagePayload] {
        // 1. Apply version filtering
        let versionFiltered = filterByVersion(
            messages: messages,
            versionSelections: conversation.versionSelections
        )

        // 2. Apply truncation
        let truncated: [SendableMessage]
        if conversation.truncateIndex > 0, conversation.truncateIndex < versionFiltered.count {
            truncated = Array(versionFiltered[conversation.truncateIndex...])
        } else {
            truncated = versionFiltered
        }

        // 3. Apply context message size limit from assistant
        let limited: [SendableMessage]
        if let assistant, assistant.limitContextMessages, !truncated.isEmpty {
            let maxMessages = max(1, assistant.contextMessageSize)
            if truncated.count > maxMessages {
                limited = Array(truncated.suffix(maxMessages))
            } else {
                limited = truncated
            }
        } else {
            limited = truncated
        }

        // 4. Convert to payloads
        var payloads: [MessagePayload] = []

        for message in limited {
            guard !message.content.isEmpty else { continue }

            let role = normalizeRole(message.role)

            // Apply message template if the assistant has one and the message is from user
            let content: String
            if role == "user", let assistant, !assistant.messageTemplate.isEmpty,
               assistant.messageTemplate != "{{ message }}"
            {
                content = PromptTransformer.applyMessageTemplate(
                    assistant.messageTemplate,
                    role: role,
                    message: message.content,
                    now: message.timestamp
                )
            } else {
                content = message.content
            }

            payloads.append(MessagePayload(role: role, content: .text(content)))
        }

        return payloads
    }

    // MARK: - Build Messages With Attachments

    /// Build message payloads with inline image and document attachments.
    ///
    /// Images are encoded as base64 content parts. Documents are inlined as
    /// text blocks prepended to the message content.
    static func buildMessageWithAttachments(
        text: String,
        role: String,
        images: [UploadedFile] = [],
        documents: [UploadedFile] = []
    ) -> MessagePayload {
        // If no attachments, return simple text message
        if images.isEmpty && documents.isEmpty {
            return MessagePayload(role: role, content: .text(text))
        }

        var parts: [ContentPart] = []

        // Add document content as text parts (prepended before user text)
        for document in documents {
            if let docText = String(data: document.data, encoding: .utf8) {
                parts.append(.text("[\(document.fileName)]:\n\(docText)"))
            }
        }

        // Add user text
        if !text.isEmpty {
            parts.append(.text(text))
        }

        // Add images as image parts
        for image in images {
            parts.append(.image(data: image.data, mimeType: image.mimeType))
        }

        return MessagePayload(role: role, content: .parts(parts))
    }

    // MARK: - Version Filtering

    /// Filter messages to include only the selected version for each group.
    ///
    /// Messages with the same `groupId` represent different versions of the
    /// same logical message. The conversation's `versionSelections` dictionary
    /// maps `groupId` to the selected `version` number.
    ///
    /// If no selection exists for a group, version 0 (the original) is used.
    private static func filterByVersion(
        messages: [SendableMessage],
        versionSelections: [String: Int]
    ) -> [SendableMessage] {
        // Group messages by groupId
        var grouped: [String: [SendableMessage]] = [:]
        var order: [String] = []

        for message in messages {
            let groupId = message.groupId ?? message.id
            if grouped[groupId] == nil {
                order.append(groupId)
            }
            grouped[groupId, default: []].append(message)
        }

        // Select the appropriate version from each group
        var result: [SendableMessage] = []

        for groupId in order {
            guard let versions = grouped[groupId] else { continue }

            if versions.count == 1 {
                result.append(versions[0])
                continue
            }

            let selectedVersion = versionSelections[groupId] ?? 0
            if let match = versions.first(where: { $0.version == selectedVersion }) {
                result.append(match)
            } else {
                // Fallback to the first version if the selected one is missing
                result.append(versions[0])
            }
        }

        return result
    }

    // MARK: - Helpers

    /// Normalize role strings to the standard set expected by LLM APIs.
    private static func normalizeRole(_ role: String) -> String {
        switch role.lowercased() {
        case "user": return "user"
        case "assistant", "ai", "bot": return "assistant"
        case "system": return "system"
        case "tool": return "tool"
        default: return role
        }
    }
}

// MARK: - Sendable Conversation Snapshot

/// A Sendable snapshot of a Conversation for crossing concurrency boundaries.
struct SendableConversation: Sendable {
    let id: String
    let title: String
    let truncateIndex: Int
    let versionSelections: [String: Int]
    let assistantId: String?
    let mcpServerIds: [String]

    init(
        id: String,
        title: String,
        truncateIndex: Int = -1,
        versionSelections: [String: Int] = [:],
        assistantId: String? = nil,
        mcpServerIds: [String] = []
    ) {
        self.id = id
        self.title = title
        self.truncateIndex = truncateIndex
        self.versionSelections = versionSelections
        self.assistantId = assistantId
        self.mcpServerIds = mcpServerIds
    }
}

// MARK: - SendableAssistant Extension

/// Adds computed properties for context message size limiting.
///
/// TODO: Add `contextMessageSize` and `limitContextMessages` fields to
/// `SendableAssistant` in `PromptTransformer.swift` to match the `Assistant`
/// model. These defaults mirror `Assistant.defaultContextMessageSize` and
/// the model's default `limitContextMessages = true`.
extension SendableAssistant {
    /// The effective context message size, defaulting to 64.
    var contextMessageSize: Int { 64 }

    /// Whether to enforce the context message size limit.
    var limitContextMessages: Bool { true }
}
