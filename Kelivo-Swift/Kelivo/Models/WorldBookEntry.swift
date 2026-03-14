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

// MARK: - Cross-platform Compatibility

/// Portable representation for cross-platform JSON import/export.
/// Flutter data may lack `sortOrder`. Default: sortOrder=0.
struct WorldBookEntryDTO: Codable {
    let id: String
    let name: String
    let isEnabled: Bool
    let priority: Int
    let position: String
    let content: String
    let injectDepth: Int
    let role: String
    let keywords: [String]
    let useRegex: Bool
    let caseSensitive: Bool
    let scanDepth: Int
    let constantActive: Bool
    let sortOrder: Int

    enum CodingKeys: String, CodingKey {
        case id, name, isEnabled, priority, position, content
        case injectDepth, role, keywords, useRegex, caseSensitive
        case scanDepth, constantActive, sortOrder
    }

    init(from model: WorldBookEntry) {
        self.id = model.id
        self.name = model.name
        self.isEnabled = model.isEnabled
        self.priority = model.priority
        self.position = model.positionRaw
        self.content = model.content
        self.injectDepth = model.injectDepth
        self.role = model.roleRaw
        self.keywords = model.keywords
        self.useRegex = model.useRegex
        self.caseSensitive = model.caseSensitive
        self.scanDepth = model.scanDepth
        self.constantActive = model.constantActive
        self.sortOrder = model.sortOrder
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled) ?? true
        priority = try container.decodeIfPresent(Int.self, forKey: .priority) ?? 0
        position = try container.decodeIfPresent(String.self, forKey: .position) ?? WorldBookInjectionPosition.afterSystemPrompt.rawValue
        content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        injectDepth = try container.decodeIfPresent(Int.self, forKey: .injectDepth) ?? 4
        role = try container.decodeIfPresent(String.self, forKey: .role) ?? WorldBookInjectionRole.user.rawValue
        keywords = try container.decodeIfPresent([String].self, forKey: .keywords) ?? []
        useRegex = try container.decodeIfPresent(Bool.self, forKey: .useRegex) ?? false
        caseSensitive = try container.decodeIfPresent(Bool.self, forKey: .caseSensitive) ?? false
        scanDepth = try container.decodeIfPresent(Int.self, forKey: .scanDepth) ?? 4
        constantActive = try container.decodeIfPresent(Bool.self, forKey: .constantActive) ?? false
        sortOrder = try container.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
    }

    func toModel() -> WorldBookEntry {
        WorldBookEntry(
            id: id,
            name: name,
            isEnabled: isEnabled,
            priority: priority,
            position: WorldBookInjectionPosition(rawValue: position) ?? .afterSystemPrompt,
            content: content,
            injectDepth: injectDepth,
            role: WorldBookInjectionRole(rawValue: role) ?? .user,
            keywords: keywords,
            useRegex: useRegex,
            caseSensitive: caseSensitive,
            scanDepth: scanDepth,
            constantActive: constantActive,
            sortOrder: sortOrder
        )
    }
}
