import Foundation
import SwiftData

// MARK: - Backup Format

enum BackupFormat: String, Sendable, Codable {
    case kelivo
    case chatbox
    case cherryStudio = "cherry_studio"
}

// MARK: - Export Data Structures

struct ExportData: Codable {
    let version: Int
    let exportedAt: Date
    let conversations: [ExportedConversation]
}

struct ExportedConversation: Codable {
    let id: String
    let title: String
    let createdAt: Date
    let updatedAt: Date
    let isPinned: Bool
    let assistantId: String?
    let messages: [ExportedMessage]
}

struct ExportedMessage: Codable {
    let id: String
    let role: String
    let content: String
    let timestamp: Date
    let modelId: String?
    let providerId: String?
    let totalTokens: Int?
    let reasoningText: String?
}

// MARK: - Data Sync Error

enum DataSyncError: Error, LocalizedError {
    case exportFailed(String)
    case importFailed(String)
    case unsupportedFormat(String)
    case noData

    var errorDescription: String? {
        switch self {
        case let .exportFailed(detail):
            return "Export failed: \(detail)"
        case let .importFailed(detail):
            return "Import failed: \(detail)"
        case let .unsupportedFormat(format):
            return "Unsupported format: \(format)"
        case .noData:
            return "No data to export"
        }
    }
}

// MARK: - Data Sync Service

@MainActor
final class DataSync {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Export

    /// Export all conversations to JSON data.
    func exportToJSON() throws -> Data {
        let descriptor = FetchDescriptor<Conversation>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        let conversations = try modelContext.fetch(descriptor)

        guard !conversations.isEmpty else {
            throw DataSyncError.noData
        }

        let exported = try conversations.map { conv -> ExportedConversation in
            let messageDescriptor = FetchDescriptor<ChatMessage>(
                predicate: #Predicate { $0.conversationId == conv.id },
                sortBy: [SortDescriptor(\.timestamp)]
            )
            let messages = try modelContext.fetch(messageDescriptor)

            return ExportedConversation(
                id: conv.id,
                title: conv.title,
                createdAt: conv.createdAt,
                updatedAt: conv.updatedAt,
                isPinned: conv.isPinned,
                assistantId: conv.assistantId,
                messages: messages.map { msg in
                    ExportedMessage(
                        id: msg.id,
                        role: msg.role,
                        content: msg.content,
                        timestamp: msg.timestamp,
                        modelId: msg.modelId,
                        providerId: msg.providerId,
                        totalTokens: msg.totalTokens,
                        reasoningText: msg.reasoningText
                    )
                }
            )
        }

        let exportData = ExportData(
            version: 1,
            exportedAt: .now,
            conversations: exported
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        return try encoder.encode(exportData)
    }

    // MARK: - Import

    /// Import conversations from JSON data in Kelivo format.
    func importFromJSON(_ data: Data) throws -> Int {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let importData = try decoder.decode(ExportData.self, from: data)
        var importedCount = 0

        for conv in importData.conversations {
            // Check for duplicate
            let existingDescriptor = FetchDescriptor<Conversation>(
                predicate: #Predicate { $0.id == conv.id }
            )
            let existing = try modelContext.fetch(existingDescriptor)
            if !existing.isEmpty { continue }

            let conversation = Conversation(
                id: conv.id,
                title: conv.title,
                createdAt: conv.createdAt,
                updatedAt: conv.updatedAt,
                messageIds: conv.messages.map(\.id),
                isPinned: conv.isPinned,
                assistantId: conv.assistantId
            )
            modelContext.insert(conversation)

            for msg in conv.messages {
                let message = ChatMessage(
                    id: msg.id,
                    role: msg.role,
                    content: msg.content,
                    timestamp: msg.timestamp,
                    modelId: msg.modelId,
                    providerId: msg.providerId,
                    totalTokens: msg.totalTokens,
                    conversationId: conv.id,
                    reasoningText: msg.reasoningText
                )
                modelContext.insert(message)
            }

            importedCount += 1
        }

        try modelContext.save()
        return importedCount
    }

    /// Import from ChatBox format.
    func importFromChatBox(_ data: Data) throws -> Int {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let sessions = json?["sessions"] as? [[String: Any]] else {
            throw DataSyncError.importFailed("Invalid ChatBox format: missing 'sessions'")
        }

        var importedCount = 0

        for session in sessions {
            guard let id = session["id"] as? String,
                  let title = session["name"] as? String ?? session["title"] as? String
            else { continue }

            // Check for duplicate
            let existingDescriptor = FetchDescriptor<Conversation>(
                predicate: #Predicate { $0.id == id }
            )
            let existing = try modelContext.fetch(existingDescriptor)
            if !existing.isEmpty { continue }

            let messages = (session["messages"] as? [[String: Any]]) ?? []

            var messageIds: [String] = []

            for msg in messages {
                let msgId = msg["id"] as? String ?? UUID().uuidString
                let role = msg["role"] as? String ?? "user"
                let content = msg["content"] as? String ?? ""

                let timestamp: Date
                if let ts = msg["timestamp"] as? TimeInterval {
                    timestamp = Date(timeIntervalSince1970: ts / 1000)
                } else {
                    timestamp = .now
                }

                let chatMessage = ChatMessage(
                    id: msgId,
                    role: role,
                    content: content,
                    timestamp: timestamp,
                    conversationId: id
                )
                modelContext.insert(chatMessage)
                messageIds.append(msgId)
            }

            let conversation = Conversation(
                id: id,
                title: title,
                messageIds: messageIds
            )
            modelContext.insert(conversation)
            importedCount += 1
        }

        try modelContext.save()
        return importedCount
    }

    /// Import from Cherry Studio format.
    func importFromCherryStudio(_ data: Data) throws -> Int {
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let topics = json?["topics"] as? [[String: Any]] else {
            throw DataSyncError.importFailed("Invalid Cherry Studio format: missing 'topics'")
        }

        var importedCount = 0

        for topic in topics {
            guard let id = topic["id"] as? String else { continue }
            let title = topic["name"] as? String ?? "Imported Conversation"

            // Check for duplicate
            let existingDescriptor = FetchDescriptor<Conversation>(
                predicate: #Predicate { $0.id == id }
            )
            let existing = try modelContext.fetch(existingDescriptor)
            if !existing.isEmpty { continue }

            let messages = (topic["messages"] as? [[String: Any]]) ?? []
            var messageIds: [String] = []

            for msg in messages {
                let msgId = msg["id"] as? String ?? UUID().uuidString
                let role = msg["role"] as? String ?? "user"
                let content = msg["content"] as? String ?? ""

                let timestamp: Date
                if let dateStr = msg["createdAt"] as? String {
                    let formatter = ISO8601DateFormatter()
                    timestamp = formatter.date(from: dateStr) ?? .now
                } else {
                    timestamp = .now
                }

                let chatMessage = ChatMessage(
                    id: msgId,
                    role: role,
                    content: content,
                    timestamp: timestamp,
                    modelId: msg["model"] as? String,
                    conversationId: id
                )
                modelContext.insert(chatMessage)
                messageIds.append(msgId)
            }

            let conversation = Conversation(
                id: id,
                title: title,
                messageIds: messageIds
            )
            modelContext.insert(conversation)
            importedCount += 1
        }

        try modelContext.save()
        return importedCount
    }

    // MARK: - Backup to WebDAV

    func backupToWebDAV(client: WebDAVClient) async throws {
        let data = try exportToJSON()
        let filename = "kelivo-backup-\(formattedTimestamp()).json"

        // Ensure directory exists
        try? await client.createDirectory(path: "")

        try await client.upload(path: filename, data: data, contentType: "application/json")
    }

    /// Restore from the latest WebDAV backup.
    func restoreFromWebDAV(client: WebDAVClient) async throws -> Int {
        let items = try await client.list()

        // Find the latest backup file
        let backupFiles = items
            .filter { !$0.isDirectory && $0.path.hasSuffix(".json") }
            .sorted { ($0.lastModified ?? .distantPast) > ($1.lastModified ?? .distantPast) }

        guard let latest = backupFiles.first else {
            throw DataSyncError.importFailed("No backup files found on WebDAV")
        }

        let data = try await client.download(path: latest.path)
        return try importFromJSON(data)
    }

    // MARK: - Backup to S3

    func backupToS3(client: S3Client) async throws {
        let data = try exportToJSON()
        let key = "kelivo-backup-\(formattedTimestamp()).json"

        try await client.putObject(key: key, data: data, contentType: "application/json")
    }

    /// Restore from the latest S3 backup.
    func restoreFromS3(client: S3Client) async throws -> Int {
        let objects = try await client.listObjects()

        let backupFiles = objects
            .filter { $0.key.hasSuffix(".json") }
            .sorted { ($0.lastModified ?? .distantPast) > ($1.lastModified ?? .distantPast) }

        guard let latest = backupFiles.first else {
            throw DataSyncError.importFailed("No backup files found on S3")
        }

        // Strip the path prefix from the key for getObject
        let data = try await client.getObject(key: latest.key)
        return try importFromJSON(data)
    }

    // MARK: - Helpers

    private func formattedTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        return formatter.string(from: .now)
    }
}
