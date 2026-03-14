import Foundation
import SwiftData

@Model
final class InstructionInjection {
    @Attribute(.unique) var id: String
    var name: String
    var content: String
    var isEnabled: Bool
    var groupId: String
    var sortOrder: Int

    init(
        id: String = UUID().uuidString,
        name: String,
        content: String,
        isEnabled: Bool = true,
        groupId: String = "",
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.content = content
        self.isEnabled = isEnabled
        self.groupId = groupId
        self.sortOrder = sortOrder
    }
}

// MARK: - Cross-platform Compatibility

extension InstructionInjection {
    /// Maps to Flutter field `title`.
    var title: String {
        get { name }
        set { name = newValue }
    }

    /// Maps to Flutter field `prompt`.
    var prompt: String {
        get { content }
        set { content = newValue }
    }

    /// Maps to Flutter field `group`.
    var group: String {
        get { groupId }
        set { groupId = newValue }
    }
}

/// Portable representation for cross-platform JSON import/export.
/// Accepts both Swift field names (`name`, `content`, `groupId`) and
/// Flutter field names (`title`, `prompt`, `group`).
struct InstructionInjectionDTO: Codable {
    let id: String
    let name: String
    let content: String
    let isEnabled: Bool
    let groupId: String
    let sortOrder: Int

    enum CodingKeys: String, CodingKey {
        case id, name, content, isEnabled, groupId, sortOrder
        // Flutter aliases
        case title, prompt, group
    }

    init(from model: InstructionInjection) {
        self.id = model.id
        self.name = model.name
        self.content = model.content
        self.isEnabled = model.isEnabled
        self.groupId = model.groupId
        self.sortOrder = model.sortOrder
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        // Prefer Swift keys; fall back to Flutter aliases
        name = try container.decodeIfPresent(String.self, forKey: .name)
            ?? container.decodeIfPresent(String.self, forKey: .title)
            ?? ""
        content = try container.decodeIfPresent(String.self, forKey: .content)
            ?? container.decodeIfPresent(String.self, forKey: .prompt)
            ?? ""
        groupId = try container.decodeIfPresent(String.self, forKey: .groupId)
            ?? container.decodeIfPresent(String.self, forKey: .group)
            ?? ""
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled) ?? true
        sortOrder = try container.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        // Encode both Swift and Flutter keys for maximum compatibility
        try container.encode(name, forKey: .name)
        try container.encode(name, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(content, forKey: .prompt)
        try container.encode(groupId, forKey: .groupId)
        try container.encode(groupId, forKey: .group)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(sortOrder, forKey: .sortOrder)
    }

    func toModel() -> InstructionInjection {
        InstructionInjection(
            id: id,
            name: name,
            content: content,
            isEnabled: isEnabled,
            groupId: groupId,
            sortOrder: sortOrder
        )
    }
}
