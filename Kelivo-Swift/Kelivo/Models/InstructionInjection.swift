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
