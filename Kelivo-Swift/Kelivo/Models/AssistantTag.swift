import Foundation
import SwiftData

@Model
final class AssistantTag {
    @Attribute(.unique) var id: String
    var name: String
    var color: String
    var sortOrder: Int

    init(
        id: String = UUID().uuidString,
        name: String,
        color: String = "",
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.sortOrder = sortOrder
    }
}

// MARK: - Cross-platform Compatibility

/// Portable representation for cross-platform JSON import/export.
/// Flutter model only has `id` and `name`. On import: `color` defaults to "",
/// `sortOrder` defaults to 0. On export: all fields are included.
struct AssistantTagDTO: Codable {
    let id: String
    let name: String
    let color: String
    let sortOrder: Int

    init(from model: AssistantTag) {
        self.id = model.id
        self.name = model.name
        self.color = model.color
        self.sortOrder = model.sortOrder
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        color = try container.decodeIfPresent(String.self, forKey: .color) ?? ""
        sortOrder = try container.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
    }

    func toModel() -> AssistantTag {
        AssistantTag(
            id: id,
            name: name,
            color: color,
            sortOrder: sortOrder
        )
    }
}
