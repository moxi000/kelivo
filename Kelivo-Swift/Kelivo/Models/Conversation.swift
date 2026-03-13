import Foundation
import SwiftData

@Model
final class Conversation {
    @Attribute(.unique) var id: String
    var title: String
    var createdAt: Date
    var updatedAt: Date
    var messageIds: [String]
    var isPinned: Bool
    var mcpServerIds: [String]
    var assistantId: String?
    var truncateIndex: Int
    var versionSelections: [String: Int]
    var summary: String?
    var lastSummarizedMessageCount: Int

    init(
        id: String = UUID().uuidString,
        title: String,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        messageIds: [String] = [],
        isPinned: Bool = false,
        mcpServerIds: [String] = [],
        assistantId: String? = nil,
        truncateIndex: Int = -1,
        versionSelections: [String: Int] = [:],
        summary: String? = nil,
        lastSummarizedMessageCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.messageIds = messageIds
        self.isPinned = isPinned
        self.mcpServerIds = mcpServerIds
        self.assistantId = assistantId
        self.truncateIndex = truncateIndex
        self.versionSelections = versionSelections
        self.summary = summary
        self.lastSummarizedMessageCount = lastSummarizedMessageCount
    }
}
