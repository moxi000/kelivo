import Foundation
import SwiftData

@Model
final class QuickPhrase {
    @Attribute(.unique) var id: String
    var title: String
    var content: String
    var sortOrder: Int
    var isEnabled: Bool
    var isGlobal: Bool
    var assistantId: String?

    init(
        id: String = UUID().uuidString,
        title: String,
        content: String,
        sortOrder: Int = 0,
        isEnabled: Bool = true,
        isGlobal: Bool = true,
        assistantId: String? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.sortOrder = sortOrder
        self.isEnabled = isEnabled
        self.isGlobal = isGlobal
        self.assistantId = assistantId
    }
}

// MARK: - Cross-platform Compatibility

/// Portable representation for cross-platform JSON import/export.
/// Flutter data may lack `sortOrder`, `isEnabled`, and `isGlobal`.
/// Defaults: sortOrder=0, isEnabled=true, isGlobal=true.
struct QuickPhraseDTO: Codable {
    let id: String
    let title: String
    let content: String
    let sortOrder: Int
    let isEnabled: Bool
    let isGlobal: Bool
    let assistantId: String?

    init(from model: QuickPhrase) {
        self.id = model.id
        self.title = model.title
        self.content = model.content
        self.sortOrder = model.sortOrder
        self.isEnabled = model.isEnabled
        self.isGlobal = model.isGlobal
        self.assistantId = model.assistantId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        sortOrder = try container.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled) ?? true
        isGlobal = try container.decodeIfPresent(Bool.self, forKey: .isGlobal) ?? true
        assistantId = try container.decodeIfPresent(String.self, forKey: .assistantId)
    }

    func toModel() -> QuickPhrase {
        QuickPhrase(
            id: id,
            title: title,
            content: content,
            sortOrder: sortOrder,
            isEnabled: isEnabled,
            isGlobal: isGlobal,
            assistantId: assistantId
        )
    }
}
