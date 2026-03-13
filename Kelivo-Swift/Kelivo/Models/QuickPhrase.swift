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
