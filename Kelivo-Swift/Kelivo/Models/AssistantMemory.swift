import Foundation
import SwiftData

@Model
final class AssistantMemory {
    @Attribute(.unique) var id: String
    var assistantId: String
    var content: String
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        assistantId: String,
        content: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.assistantId = assistantId
        self.content = content
        self.createdAt = createdAt
    }
}

// MARK: - Cross-platform Compatibility

/// Portable representation for cross-platform JSON import/export.
/// Flutter uses `int` auto-increment id; Swift uses `String` UUID.
/// On import: int id is converted to String. On export: if the id is
/// a pure integer string, it is encoded as int for Flutter compatibility.
struct AssistantMemoryDTO: Codable {
    let id: String
    let assistantId: String
    let content: String
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, assistantId, content, createdAt
    }

    init(from model: AssistantMemory) {
        self.id = model.id
        self.assistantId = model.assistantId
        self.content = model.content
        self.createdAt = model.createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Accept both int and string for id
        if let intId = try? container.decode(Int.self, forKey: .id) {
            id = String(intId)
        } else {
            id = try container.decode(String.self, forKey: .id)
        }
        assistantId = try container.decode(String.self, forKey: .assistantId)
        content = try container.decode(String.self, forKey: .content)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // If id is a pure integer, encode as int for Flutter compatibility
        if let intId = Int(id) {
            try container.encode(intId, forKey: .id)
        } else {
            try container.encode(id, forKey: .id)
        }
        try container.encode(assistantId, forKey: .assistantId)
        try container.encode(content, forKey: .content)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
    }

    func toModel() -> AssistantMemory {
        AssistantMemory(
            id: id,
            assistantId: assistantId,
            content: content,
            createdAt: createdAt ?? .now
        )
    }
}
