import Foundation

/// Manages all registered search providers and routes search requests.
actor SearchServiceManager {
    static let shared = SearchServiceManager()

    private var providers: [String: any SearchProvider] = [:]
    private var activeProviderId: String?

    private init() {
        // Register the default provider that requires no API key
        let ddg = DuckDuckGoSearch()
        providers[ddg.id] = ddg
    }

    // MARK: - Provider Management

    /// Register a search provider.
    func register(_ provider: any SearchProvider) {
        providers[provider.id] = provider
    }

    /// Remove a search provider by ID.
    func unregister(providerId: String) {
        providers.removeValue(forKey: providerId)
        if activeProviderId == providerId {
            activeProviderId = nil
        }
    }

    /// Set the active search provider by ID.
    func setActiveProvider(id: String) throws {
        guard providers[id] != nil else {
            throw SearchError.invalidConfiguration("Search provider '\(id)' is not registered")
        }
        activeProviderId = id
    }

    /// Get the currently active provider, falling back to DuckDuckGo.
    func activeProvider() -> any SearchProvider {
        if let id = activeProviderId, let provider = providers[id] {
            return provider
        }
        // Default fallback
        return providers["duckduckgo"] ?? DuckDuckGoSearch()
    }

    /// List all registered provider IDs and names.
    func availableProviders() -> [(id: String, name: String)] {
        providers.map { ($0.key, $0.value.name) }.sorted { $0.name < $1.name }
    }

    // MARK: - Search

    /// Perform a search using the active provider.
    func search(query: String, maxResults: Int = 10) async throws -> [SearchResult] {
        let provider = activeProvider()
        return try await provider.search(query: query, maxResults: maxResults)
    }

    /// Perform a search using a specific provider.
    func search(
        query: String,
        maxResults: Int = 10,
        providerId: String
    ) async throws -> [SearchResult] {
        guard let provider = providers[providerId] else {
            throw SearchError.invalidConfiguration("Search provider '\(providerId)' is not registered")
        }
        return try await provider.search(query: query, maxResults: maxResults)
    }
}
