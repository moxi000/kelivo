import Foundation
import Security

// MARK: - Keychain Error

enum KeychainError: Error, LocalizedError {
    case saveFailed(OSStatus)
    case readFailed(OSStatus)
    case deleteFailed(OSStatus)
    case dataConversionFailed
    case itemNotFound

    var errorDescription: String? {
        switch self {
        case let .saveFailed(status):
            return "Keychain save failed: \(SecCopyErrorMessageString(status, nil) as String? ?? "unknown error")"
        case let .readFailed(status):
            return "Keychain read failed: \(SecCopyErrorMessageString(status, nil) as String? ?? "unknown error")"
        case let .deleteFailed(status):
            return "Keychain delete failed: \(SecCopyErrorMessageString(status, nil) as String? ?? "unknown error")"
        case .dataConversionFailed:
            return "Failed to convert keychain data"
        case .itemNotFound:
            return "Keychain item not found"
        }
    }
}

// MARK: - Keychain Manager

/// Thread-safe Keychain wrapper for storing API keys and secrets.
final class KeychainManager: Sendable {
    static let shared = KeychainManager()

    private let service: String
    private let accessGroup: String?

    init(
        service: String = Bundle.main.bundleIdentifier ?? "com.kelivo.app",
        accessGroup: String? = nil
    ) {
        self.service = service
        self.accessGroup = accessGroup
    }

    // MARK: - Store

    /// Save a string value to the keychain for the given key.
    func save(_ value: String, forKey key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.dataConversionFailed
        }
        try save(data: data, forKey: key)
    }

    /// Save raw data to the keychain for the given key.
    func save(data: Data, forKey key: String) throws {
        // Delete existing item first
        try? delete(forKey: key)

        var query = baseQuery(forKey: key)
        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    // MARK: - Retrieve

    /// Retrieve a string value from the keychain for the given key.
    func retrieve(forKey key: String) throws -> String {
        let data = try retrieveData(forKey: key)
        guard let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.dataConversionFailed
        }
        return string
    }

    /// Retrieve raw data from the keychain for the given key.
    func retrieveData(forKey key: String) throws -> Data {
        var query = baseQuery(forKey: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }

        guard status == errSecSuccess, let data = result as? Data else {
            throw KeychainError.readFailed(status)
        }

        return data
    }

    /// Retrieve a string value, returning nil if not found.
    func retrieveOptional(forKey key: String) -> String? {
        try? retrieve(forKey: key)
    }

    // MARK: - Delete

    /// Delete a keychain item by key.
    func delete(forKey key: String) throws {
        let query = baseQuery(forKey: key)
        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }

    /// Delete all items for this service.
    func deleteAll() throws {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
        ]
        if let accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }

    // MARK: - Convenience: API Keys

    /// Save an API key for a provider.
    func saveAPIKey(_ key: String, forProvider providerId: String) throws {
        try save(key, forKey: apiKeyKey(providerId))
    }

    /// Retrieve an API key for a provider.
    func apiKey(forProvider providerId: String) -> String? {
        retrieveOptional(forKey: apiKeyKey(providerId))
    }

    /// Delete an API key for a provider.
    func deleteAPIKey(forProvider providerId: String) throws {
        try delete(forKey: apiKeyKey(providerId))
    }

    /// Check if an API key exists for a provider.
    func hasAPIKey(forProvider providerId: String) -> Bool {
        apiKey(forProvider: providerId) != nil
    }

    // MARK: - Private

    private func baseQuery(forKey key: String) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
        if let accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        return query
    }

    private func apiKeyKey(_ providerId: String) -> String {
        "api_key_\(providerId)"
    }
}
