import Foundation
import SwiftData

// MARK: - Import Result

struct ImportResult: Sendable {
    let conversations: Int
    let messages: Int
}

// MARK: - ChatBox Import Error

enum ChatBoxImportError: Error, LocalizedError {
    case fileNotFound
    case invalidJSON
    case invalidFormat(String)
    case importFailed(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "ChatBox backup file not found"
        case .invalidJSON:
            return "Invalid JSON: unable to parse ChatBox backup file"
        case let .invalidFormat(detail):
            return "Invalid ChatBox format: \(detail)"
        case let .importFailed(detail):
            return "ChatBox import failed: \(detail)"
        }
    }
}

// MARK: - ChatBox Importer

@MainActor
final class ChatBoxImporter {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    /// Import conversations from a ChatBox JSON export file.
    func importFromFile(_ url: URL) async throws -> ImportResult {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw ChatBoxImportError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        let root = try parseRoot(data)

        let sessionsList = root["chat-sessions-list"] as? [[String: Any]]
        guard let sessionsList, !sessionsList.isEmpty else {
            throw ChatBoxImportError.invalidFormat("missing 'chat-sessions-list'")
        }

        var totalConversations = 0
        var totalMessages = 0

        for meta in sessionsList {
            guard let sessionId = meta["id"] as? String,
                  !sessionId.trimmingCharacters(in: .whitespaces).isEmpty
            else { continue }

            let title = (meta["name"] as? String) ?? (meta["title"] as? String) ?? sessionId
            let starred = (meta["starred"] as? Bool) ?? false

            // Check for duplicate
            let existingDescriptor = FetchDescriptor<Conversation>(
                predicate: #Predicate { $0.id == sessionId }
            )
            let existing = try modelContext.fetch(existingDescriptor)
            if !existing.isEmpty { continue }

            // Parse session data
            let session = root["session:\(sessionId)"] as? [String: Any]
            let rawMessages = session?["messages"] as? [[String: Any]]
                ?? (root["session:\(sessionId)"] as? [[String: Any]])
                ?? []

            var messageIds: [String] = []
            var firstTimestamp: Date?
            var lastTimestamp: Date?

            for rawMsg in rawMessages {
                let msgId = (rawMsg["id"] as? String) ?? UUID().uuidString
                let role = normalizeRole(rawMsg["role"] as? String ?? "user")
                let content = extractContent(from: rawMsg)

                // Skip system messages (used as prompts in ChatBox)
                if (rawMsg["role"] as? String) == "system" { continue }

                let timestamp = parseTimestamp(rawMsg["timestamp"]) ?? .now

                if firstTimestamp == nil || timestamp < firstTimestamp! {
                    firstTimestamp = timestamp
                }
                if lastTimestamp == nil || timestamp > lastTimestamp! {
                    lastTimestamp = timestamp
                }

                let modelId = extractModelId(from: rawMsg)

                let chatMessage = ChatMessage(
                    id: msgId,
                    role: role,
                    content: content,
                    timestamp: timestamp,
                    modelId: modelId,
                    conversationId: sessionId
                )
                modelContext.insert(chatMessage)
                messageIds.append(msgId)
            }

            let conversation = Conversation(
                id: sessionId,
                title: title,
                createdAt: firstTimestamp ?? .now,
                updatedAt: lastTimestamp ?? .now,
                messageIds: messageIds,
                isPinned: starred
            )
            modelContext.insert(conversation)

            totalConversations += 1
            totalMessages += messageIds.count
        }

        try modelContext.save()
        return ImportResult(conversations: totalConversations, messages: totalMessages)
    }

    // MARK: - Parsing Helpers

    private func parseRoot(_ data: Data) throws -> [String: Any] {
        let object: Any
        do {
            object = try JSONSerialization.jsonObject(with: data)
        } catch {
            throw ChatBoxImportError.invalidJSON
        }

        guard let root = object as? [String: Any] else {
            throw ChatBoxImportError.invalidFormat("expected a JSON object at root")
        }

        // Validate minimal shape
        let hasSessions = root["chat-sessions-list"] is [[String: Any]]
        let settings = root["settings"] as? [String: Any]
        let hasProviders = settings?["providers"] is [String: Any]

        if !hasSessions && !hasProviders {
            throw ChatBoxImportError.invalidFormat(
                "missing 'chat-sessions-list' and 'settings.providers'"
            )
        }

        return root
    }

    private func normalizeRole(_ role: String) -> String {
        switch role {
        case "user": return "user"
        case "tool": return "tool"
        default: return "assistant"
        }
    }

    private func extractContent(from msg: [String: Any]) -> String {
        // Try contentParts first (newer ChatBox format)
        if let parts = msg["contentParts"] as? [[String: Any]] {
            var texts: [String] = []
            for part in parts {
                let type = part["type"] as? String ?? ""
                switch type {
                case "text":
                    if let text = part["text"] as? String, !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        texts.append(text)
                    }
                case "image":
                    let url = part["url"] as? String ?? ""
                    if !url.isEmpty { texts.append("[image:\(url)]") }
                case "reasoning":
                    if let text = part["text"] as? String, !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        texts.append("<think>\n\(text)\n</think>")
                    }
                default:
                    break
                }
            }
            if !texts.isEmpty {
                return texts.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        // Fallback to legacy content field
        return (msg["content"] as? String) ?? ""
    }

    private func extractModelId(from msg: [String: Any]) -> String? {
        guard let raw = msg["model"] as? String, !raw.isEmpty else { return nil }
        // ChatBox sometimes formats model as "Display Name (model-id)"
        if let match = raw.range(of: #"\(([^)]+)\)\s*$"#, options: .regularExpression) {
            let inner = raw[match].dropFirst().dropLast()
            let trimmed = inner.trimmingCharacters(in: .whitespaces)
            return trimmed.isEmpty ? nil : trimmed
        }
        return raw
    }

    private func parseTimestamp(_ raw: Any?) -> Date? {
        if let ms = raw as? Double {
            return Date(timeIntervalSince1970: ms / 1000)
        }
        if let ms = raw as? Int {
            return Date(timeIntervalSince1970: TimeInterval(ms) / 1000)
        }
        if let str = raw as? String, let ms = Double(str) {
            return Date(timeIntervalSince1970: ms / 1000)
        }
        return nil
    }
}
