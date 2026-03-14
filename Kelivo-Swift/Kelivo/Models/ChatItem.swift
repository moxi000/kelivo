import Foundation

struct ChatItem: Identifiable, Equatable {
    let id: String
    var title: String
    let created: Date

    init(id: String, title: String, created: Date) {
        self.id = id
        self.title = title
        self.created = created
    }

    func copyWith(
        id: String? = nil,
        title: String? = nil,
        created: Date? = nil
    ) -> ChatItem {
        ChatItem(
            id: id ?? self.id,
            title: title ?? self.title,
            created: created ?? self.created
        )
    }
}
