import Foundation

// MARK: - Enums

enum ModelType: String, Codable, CaseIterable {
    case chat
    case embedding
}

enum Modality: String, Codable, CaseIterable {
    case text
    case image
}

enum ModelAbility: String, Codable, CaseIterable {
    case tool
    case reasoning
}

// MARK: - ModelInfo

struct ModelInfo: Codable, Identifiable, Hashable {
    let id: String
    var displayName: String
    var type: ModelType
    var input: [Modality]
    var output: [Modality]
    var abilities: [ModelAbility]

    init(
        id: String,
        displayName: String,
        type: ModelType = .chat,
        input: [Modality] = [.text],
        output: [Modality] = [.text],
        abilities: [ModelAbility] = []
    ) {
        self.id = id
        self.displayName = displayName
        self.type = type
        self.input = Self.normalizeModalities(input)
        self.output = Self.normalizeModalities(output)
        self.abilities = Self.normalizeAbilities(abilities)
    }

    func copyWith(
        id: String? = nil,
        displayName: String? = nil,
        type: ModelType? = nil,
        input: [Modality]? = nil,
        output: [Modality]? = nil,
        abilities: [ModelAbility]? = nil
    ) -> ModelInfo {
        ModelInfo(
            id: id ?? self.id,
            displayName: displayName ?? self.displayName,
            type: type ?? self.type,
            input: input ?? self.input,
            output: output ?? self.output,
            abilities: abilities ?? self.abilities
        )
    }

    // MARK: - Normalization

    /// Deduplicate and sort modalities by raw value for consistent comparison.
    private static func normalizeModalities(_ mods: [Modality]) -> [Modality] {
        Array(Set(mods)).sorted { $0.rawValue < $1.rawValue }
    }

    /// Deduplicate and sort abilities by raw value for consistent comparison.
    private static func normalizeAbilities(_ abs: [ModelAbility]) -> [ModelAbility] {
        Array(Set(abs)).sorted { $0.rawValue < $1.rawValue }
    }
}
