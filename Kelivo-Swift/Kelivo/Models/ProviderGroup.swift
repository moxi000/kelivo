import Foundation

struct ProviderGroup: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    let createdAt: Int

    init(
        id: String = UUID().uuidString,
        name: String,
        createdAt: Int = Int(Date().timeIntervalSince1970 * 1000)
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }

    func copyWith(
        id: String? = nil,
        name: String? = nil,
        createdAt: Int? = nil
    ) -> ProviderGroup {
        ProviderGroup(
            id: id ?? self.id,
            name: name ?? self.name,
            createdAt: createdAt ?? self.createdAt
        )
    }

    // MARK: - List serialization

    /// Encode an array of ProviderGroup to a JSON string.
    static func encodeList(_ list: [ProviderGroup]) -> String {
        guard let data = try? JSONEncoder().encode(list),
              let json = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return json
    }

    /// Decode a JSON string into an array of ProviderGroup.
    static func decodeList(_ raw: String) -> [ProviderGroup] {
        guard let data = raw.data(using: .utf8),
              let list = try? JSONDecoder().decode([ProviderGroup].self, from: data) else {
            return []
        }
        return list
    }
}
