import Foundation
import SwiftData

@Model
final class ChatMessage {
    @Attribute(.unique) var id: String
    var role: String
    var content: String
    var timestamp: Date
    var modelId: String?
    var providerId: String?
    var totalTokens: Int?
    var conversationId: String
    var isStreaming: Bool
    var reasoningText: String?
    var reasoningStartAt: Date?
    var reasoningFinishedAt: Date?
    var translation: String?
    var reasoningSegmentsJson: String?
    var groupId: String?
    var version: Int

    init(
        id: String = UUID().uuidString,
        role: String,
        content: String,
        timestamp: Date = .now,
        modelId: String? = nil,
        providerId: String? = nil,
        totalTokens: Int? = nil,
        conversationId: String,
        isStreaming: Bool = false,
        reasoningText: String? = nil,
        reasoningStartAt: Date? = nil,
        reasoningFinishedAt: Date? = nil,
        translation: String? = nil,
        reasoningSegmentsJson: String? = nil,
        groupId: String? = nil,
        version: Int = 0
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.modelId = modelId
        self.providerId = providerId
        self.totalTokens = totalTokens
        self.conversationId = conversationId
        self.isStreaming = isStreaming
        self.reasoningText = reasoningText
        self.reasoningStartAt = reasoningStartAt
        self.reasoningFinishedAt = reasoningFinishedAt
        self.translation = translation
        self.reasoningSegmentsJson = reasoningSegmentsJson
        self.groupId = groupId ?? id
        self.version = version
    }
}
