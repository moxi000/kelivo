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
