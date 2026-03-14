import Foundation
import SwiftData

// MARK: - Cherry Studio Import Error

enum CherryStudioImportError: Error, LocalizedError {
    case fileNotFound
    case invalidJSON
    case invalidFormat(String)
    case importFailed(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Cherry Studio export file not found"
        case .invalidJSON:
            return "Invalid JSON: unable to parse Cherry Studio export"
        case let .invalidFormat(detail):
            return "Invalid Cherry Studio format: \(detail)"
        case let .importFailed(detail):
            return "Cherry Studio import failed: \(detail)"
        }
    }
}

// MARK: - Cherry Studio Importer

@MainActor
final class CherryStudioImporter {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    /// Import conversations from a Cherry Studio JSON export file.
    func importFromFile(_ url: URL) async throws -> ImportResult {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw CherryStudioImportError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        let root = try parseRoot(data)

        guard let topics = root["topics"] as? [[String: Any]], !topics.isEmpty else {
            throw CherryStudioImportError.invalidFormat("missing 'topics'")
        }

        var totalConversations = 0
        var totalMessages = 0

        for topic in topics {
            guard let topicId = topic["id"] as? String, !topicId.isEmpty else { continue }

            let title = (topic["name"] as? String) ?? "Imported Conversation"

            // Check for duplicate
            let existingDescriptor = FetchDescriptor<Conversation>(
                predicate: #Predicate { $0.id == topicId }
            )
            let existing = try modelContext.fetch(existingDescriptor)
            if !existing.isEmpty { continue }

            let rawMessages = (topic["messages"] as? [[String: Any]]) ?? []
            var messageIds: [String] = []
            var firstTimestamp: Date?
            var lastTimestamp: Date?

            for rawMsg in rawMessages {
                let msgId = (rawMsg["id"] as? String) ?? UUID().uuidString
                let role = normalizeRole(rawMsg["role"] as? String ?? "user")
                let content = extractContent(from: rawMsg)

                let timestamp = parseTimestamp(rawMsg["createdAt"]) ?? .now

                if firstTimestamp == nil || timestamp < firstTimestamp! {
                    firstTimestamp = timestamp
                }
                if lastTimestamp == nil || timestamp > lastTimestamp! {
                    lastTimestamp = timestamp
                }

                let modelId = rawMsg["model"] as? String

                let chatMessage = ChatMessage(
                    id: msgId,
                    role: role,
                    content: content,
                    timestamp: timestamp,
                    modelId: modelId,
                    conversationId: topicId
                )
                modelContext.insert(chatMessage)
                messageIds.append(msgId)
            }

            // Parse topic-level timestamps
            let createdAt = parseTimestamp(topic["createdAt"]) ?? firstTimestamp ?? .now
            let updatedAt = parseTimestamp(topic["updatedAt"]) ?? lastTimestamp ?? createdAt

            let conversation = Conversation(
                id: topicId,
                title: title,
                createdAt: createdAt,
                updatedAt: updatedAt,
                messageIds: messageIds
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
            throw CherryStudioImportError.invalidJSON
        }

        guard let root = object as? [String: Any] else {
            throw CherryStudioImportError.invalidFormat("expected a JSON object at root")
        }

        guard root["topics"] is [[String: Any]] else {
            throw CherryStudioImportError.invalidFormat("missing 'topics' array")
        }

        return root
    }

    private func normalizeRole(_ role: String) -> String {
        switch role {
        case "user": return "user"
        case "system": return "assistant"
        case "tool": return "tool"
        default: return "assistant"
        }
    }

    private func extractContent(from msg: [String: Any]) -> String {
        // Cherry Studio stores content as a string
        if let content = msg["content"] as? String {
            return content
        }

        // Some exports may use a parts array
        if let parts = msg["parts"] as? [[String: Any]] {
            var texts: [String] = []
            for part in parts {
                if let text = part["text"] as? String {
                    texts.append(text)
                }
            }
            return texts.joined(separator: "\n")
        }

        return ""
    }

    private func parseTimestamp(_ raw: Any?) -> Date? {
        // ISO 8601 string format
        if let dateStr = raw as? String {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: dateStr) {
                return date
            }
            // Try without fractional seconds
            formatter.formatOptions = [.withInternetDateTime]
            return formatter.date(from: dateStr)
        }
        // Epoch milliseconds
        if let ms = raw as? Double {
            return Date(timeIntervalSince1970: ms / 1000)
        }
        if let ms = raw as? Int {
            return Date(timeIntervalSince1970: TimeInterval(ms) / 1000)
        }
        return nil
    }
}
