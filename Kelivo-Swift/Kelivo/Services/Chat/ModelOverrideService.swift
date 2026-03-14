import Foundation

/// Resolves per-model overrides (assistant-level vs global defaults).
///
/// Mirrors the logic from Flutter's `ModelOverrideResolver`:
/// parses override maps that may contain type, modality, ability, and
/// display name changes, then applies them onto a base `ModelInfo`.
enum ModelOverrideService {

    // MARK: - Public API

    /// Apply a per-model override dictionary onto a base `ModelInfo`.
    ///
    /// - Parameters:
    ///   - base: The original model info to override.
    ///   - overrides: A dictionary of override values (e.g. from assistant config or provider JSON).
    ///   - applyDisplayName: Whether to apply the `name` key from overrides.
    /// - Returns: A new `ModelInfo` with overrides applied, or the original if nothing changed.
    static func applyOverrides(
        to base: ModelInfo,
        from overrides: [String: Any],
        applyDisplayName: Bool = false
    ) -> ModelInfo {
        let typeOverride = parseModelType(from: overrides)
        let effectiveType = typeOverride ?? base.type

        let nameOverride = applyDisplayName ? parseName(from: overrides) : nil
        let displayName = nameOverride ?? base.displayName

        let inputOverride = parseModalities(overrides["input"])
        let outputOverride = (effectiveType == .embedding)
            ? nil
            : parseModalities(overrides["output"])
        let abilitiesOverride = (effectiveType == .embedding)
            ? nil
            : parseAbilities(overrides["abilities"])

        let hasOverrides =
            (typeOverride != nil && typeOverride != base.type)
            || (nameOverride != nil && nameOverride != base.displayName)
            || inputOverride != nil
            || outputOverride != nil
            || abilitiesOverride != nil

        guard hasOverrides else { return base }

        if effectiveType == .embedding {
            let inMods = nonEmpty(inputOverride ?? base.input)
            return base.copyWith(
                displayName: displayName,
                type: .embedding,
                input: inMods,
                output: [.text],
                abilities: []
            )
        }

        let inMods = nonEmpty(inputOverride ?? base.input)
        let outMods = nonEmpty(outputOverride ?? base.output)

        return base.copyWith(
            displayName: displayName,
            type: effectiveType,
            input: inMods,
            output: outMods,
            abilities: abilitiesOverride ?? base.abilities
        )
    }

    /// Resolve which model to use: assistant-level override or global default.
    ///
    /// - Parameters:
    ///   - assistant: The current assistant (may specify its own provider/model).
    ///   - globalProviderId: The global default provider id from settings.
    ///   - globalModelId: The global default model id from settings.
    /// - Returns: A tuple of (providerId, modelId) to use.
    static func resolveModel(
        for assistant: Assistant,
        globalProviderId: String,
        globalModelId: String
    ) -> (providerId: String, modelId: String) {
        let providerId: String
        let modelId: String

        if let assistantProvider = assistant.chatModelProvider, !assistantProvider.isEmpty,
           let assistantModel = assistant.chatModelId, !assistantModel.isEmpty
        {
            providerId = assistantProvider
            modelId = assistantModel
        } else {
            providerId = globalProviderId
            modelId = globalModelId
        }

        return (providerId, modelId)
    }

    // MARK: - Parsing Helpers

    private static let embeddingTypeStrings: Set<String> = ["embedding", "embeddings"]
    private static let chatTypeStrings: Set<String> = ["chat"]

    private static func norm(_ value: Any?) -> String {
        guard let value else { return "" }
        return String(describing: value).trimmingCharacters(in: .whitespaces).lowercased()
    }

    static func parseModelType(from overrides: [String: Any]) -> ModelType? {
        let t = norm(overrides["type"] ?? overrides["t"])
        if embeddingTypeStrings.contains(t) { return .embedding }
        if chatTypeStrings.contains(t) { return .chat }
        return nil
    }

    static func parseModalities(_ raw: Any?) -> [Modality]? {
        guard let list = raw as? [Any] else { return nil }
        if list.isEmpty { return [] }

        var result: [Modality] = []
        for element in list {
            let s = norm(element)
            switch s {
            case "text": result.append(.text)
            case "image": result.append(.image)
            default: break
            }
        }
        guard !result.isEmpty else { return nil }
        // Deduplicate while preserving order
        return Array(NSOrderedSet(array: result)) as? [Modality] ?? result
    }

    static func parseAbilities(_ raw: Any?) -> [ModelAbility]? {
        guard let list = raw as? [Any] else { return nil }
        if list.isEmpty { return [] }

        var result: [ModelAbility] = []
        for element in list {
            let s = norm(element)
            switch s {
            case "tool": result.append(.tool)
            case "reasoning": result.append(.reasoning)
            default: break
            }
        }
        guard !result.isEmpty else { return nil }
        return Array(NSOrderedSet(array: result)) as? [ModelAbility] ?? result
    }

    private static func parseName(from overrides: [String: Any]) -> String? {
        guard let n = overrides["name"] else { return nil }
        let s = String(describing: n).trimmingCharacters(in: .whitespaces)
        return s.isEmpty ? nil : s
    }

    private static func nonEmpty(_ mods: [Modality]) -> [Modality] {
        mods.isEmpty ? [.text] : mods
    }
}
