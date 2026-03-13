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
