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

// MARK: - Cross-platform Compatibility

/// Portable representation for cross-platform JSON import/export.
/// Flutter data may lack `id`, `messageId`, and `estimatedCost`.
/// Defaults: id=UUID, messageId="", estimatedCost=nil.
struct TokenUsageDTO: Codable {
    let id: String
    let messageId: String
    let promptTokens: Int
    let completionTokens: Int
    let cachedTokens: Int
    let totalTokens: Int
    let estimatedCost: Double?

    init(from model: TokenUsage) {
        self.id = model.id
        self.messageId = model.messageId
        self.promptTokens = model.promptTokens
        self.completionTokens = model.completionTokens
        self.cachedTokens = model.cachedTokens
        self.totalTokens = model.totalTokens
        self.estimatedCost = model.estimatedCost
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        messageId = try container.decodeIfPresent(String.self, forKey: .messageId) ?? ""
        promptTokens = try container.decodeIfPresent(Int.self, forKey: .promptTokens) ?? 0
        completionTokens = try container.decodeIfPresent(Int.self, forKey: .completionTokens) ?? 0
        cachedTokens = try container.decodeIfPresent(Int.self, forKey: .cachedTokens) ?? 0
        totalTokens = try container.decodeIfPresent(Int.self, forKey: .totalTokens) ?? 0
        estimatedCost = try container.decodeIfPresent(Double.self, forKey: .estimatedCost)
    }

    func toModel() -> TokenUsage {
        TokenUsage(
            id: id,
            messageId: messageId,
            promptTokens: promptTokens,
            completionTokens: completionTokens,
            cachedTokens: cachedTokens,
            totalTokens: totalTokens,
            estimatedCost: estimatedCost
        )
    }
}
