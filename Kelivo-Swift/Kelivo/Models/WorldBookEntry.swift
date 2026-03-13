import Foundation
import SwiftData

enum WorldBookInjectionPosition: String, Codable, CaseIterable {
    case beforeSystemPrompt
    case afterSystemPrompt
    case topOfChat
    case bottomOfChat
    case atDepth
}

enum WorldBookInjectionRole: String, Codable, CaseIterable {
    case user
    case assistant
}

@Model
final class WorldBookEntry {
    @Attribute(.unique) var id: String
    var name: String
    var isEnabled: Bool
    var priority: Int
    var positionRaw: String
    var content: String
    var injectDepth: Int
    var roleRaw: String
    var keywords: [String]
    var useRegex: Bool
    var caseSensitive: Bool
    var scanDepth: Int
    var constantActive: Bool
    var sortOrder: Int

    /// Typed access to injection position.
    var position: WorldBookInjectionPosition {
        get { WorldBookInjectionPosition(rawValue: positionRaw) ?? .afterSystemPrompt }
        set { positionRaw = newValue.rawValue }
    }

    /// Typed access to injection role.
    var role: WorldBookInjectionRole {
        get { WorldBookInjectionRole(rawValue: roleRaw) ?? .user }
        set { roleRaw = newValue.rawValue }
    }

    init(
        id: String = UUID().uuidString,
        name: String = "",
        isEnabled: Bool = true,
        priority: Int = 0,
        position: WorldBookInjectionPosition = .afterSystemPrompt,
        content: String = "",
        injectDepth: Int = 4,
        role: WorldBookInjectionRole = .user,
        keywords: [String] = [],
        useRegex: Bool = false,
        caseSensitive: Bool = false,
        scanDepth: Int = 4,
        constantActive: Bool = false,
        sortOrder: Int = 0
    ) {
        self.id = id
        self.name = name
        self.isEnabled = isEnabled
        self.priority = priority
        self.positionRaw = position.rawValue
        self.content = content
        self.injectDepth = injectDepth
        self.roleRaw = role.rawValue
        self.keywords = keywords
        self.useRegex = useRegex
        self.caseSensitive = caseSensitive
        self.scanDepth = scanDepth
        self.constantActive = constantActive
        self.sortOrder = sortOrder
    }
}
