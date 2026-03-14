import Foundation
import SwiftData

@Model
final class PresetMessage {
    @Attribute(.unique) var id: String
    var role: String
    var content: String
    var sortOrder: Int

    init(
        id: String = UUID().uuidString,
        role: String,
        content: String,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.sortOrder = sortOrder
    }
}

// MARK: - Cross-platform Compatibility

/// Portable representation for cross-platform JSON import/export.
/// Flutter data may lack `sortOrder`. Default: sortOrder=0.
struct PresetMessageDTO: Codable {
    let id: String
    let role: String
    let content: String
    let sortOrder: Int

    init(from model: PresetMessage) {
        self.id = model.id
        self.role = model.role
        self.content = model.content
        self.sortOrder = model.sortOrder
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        role = try container.decode(String.self, forKey: .role)
        content = try container.decode(String.self, forKey: .content)
        sortOrder = try container.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
    }

    func toModel() -> PresetMessage {
        PresetMessage(
            id: id,
            role: role,
            content: content,
            sortOrder: sortOrder
        )
    }
}
