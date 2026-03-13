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
