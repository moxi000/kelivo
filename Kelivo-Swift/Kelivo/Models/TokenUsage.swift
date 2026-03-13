import Foundation
import SwiftData

@Model
final class TokenUsage {
    @Attribute(.unique) var id: String
    var messageId: String
    var promptTokens: Int
    var completionTokens: Int
    var cachedTokens: Int
    var totalTokens: Int
    var estimatedCost: Double?

    init(
        id: String = UUID().uuidString,
        messageId: String,
        promptTokens: Int = 0,
        completionTokens: Int = 0,
        cachedTokens: Int = 0,
        totalTokens: Int = 0,
        estimatedCost: Double? = nil
    ) {
        self.id = id
        self.messageId = messageId
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        self.cachedTokens = cachedTokens
        self.totalTokens = totalTokens
        self.estimatedCost = estimatedCost
    }
}
