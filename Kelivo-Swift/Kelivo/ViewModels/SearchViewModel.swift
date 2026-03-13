import Foundation
import Observation

// MARK: - Supporting Types

struct SearchResult: Identifiable, Sendable {
    let id: String
    let title: String
    let url: String
    let snippet: String
    let source: String

    init(
        id: String = UUID().uuidString,
        title: String,
        url: String,
        snippet: String,
        source: String
    ) {
        self.id = id
        self.title = title
        self.url = url
        self.snippet = snippet
        self.source = source
    }
}

// MARK: - SearchViewModel

@Observable
final class SearchViewModel {

    // MARK: - Nested Types

    struct SearchProviderConfig: Identifiable, Codable, Sendable {
        var id: String
        var type: SearchProviderType
        var apiKey: String?
        var baseUrl: String?
        var isEnabled: Bool

        enum SearchProviderType: String, Codable, CaseIterable, Sendable {
            case duckduckgo
            case brave
            case jina
            case tavily
            case perplexity
            case searxng
            case google
            case bing
            case exa
            case bocha
        }

        init(
            id: String = UUID().uuidString,
            type: SearchProviderType,
            apiKey: String? = nil,
            baseUrl: String? = nil,
            isEnabled: Bool = true
        ) {
            self.id = id
            self.type = type
            self.apiKey = apiKey
            self.baseUrl = baseUrl
            self.isEnabled = isEnabled
        }
    }

    // MARK: Published State

    var searchProviders: [SearchProviderConfig] = []
    var activeProviderId: String?
    var isSearching: Bool = false
    var lastResults: [SearchResult] = []

    // MARK: - Persistence Key

    private static let storageKey = "search.providers"
    private static let activeProviderKey = "search.activeProviderId"

    // MARK: - Provider Management

    func loadProviders() {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let decoded = try? JSONDecoder().decode([SearchProviderConfig].self, from: data)
        {
            searchProviders = decoded
        }
        activeProviderId = UserDefaults.standard.string(forKey: Self.activeProviderKey)
    }

    func setActiveProvider(_ id: String) {
        activeProviderId = id
        UserDefaults.standard.set(id, forKey: Self.activeProviderKey)
    }

    // MARK: - Search

    func search(query: String) async throws -> [SearchResult] {
        guard let activeId = activeProviderId,
              let provider = searchProviders.first(where: { $0.id == activeId && $0.isEnabled })
        else {
            throw SearchError.noActiveProvider
        }

        isSearching = true
        defer { isSearching = false }

        let results: [SearchResult]

        switch provider.type {
        case .duckduckgo:
            // TODO: Implement DuckDuckGo search API call
            results = []
        case .brave:
            // TODO: Implement Brave search API call
            results = []
        case .jina:
            // TODO: Implement Jina search API call
            results = []
        case .tavily:
            // TODO: Implement Tavily search API call
            results = []
        case .perplexity:
            // TODO: Implement Perplexity search API call
            results = []
        case .searxng:
            // TODO: Implement SearXNG search API call
            results = []
        case .google:
            // TODO: Implement Google Custom Search API call
            results = []
        case .bing:
            // TODO: Implement Bing search API call
            results = []
        case .exa:
            // TODO: Implement Exa search API call
            results = []
        case .bocha:
            // TODO: Implement Bocha search API call
            results = []
        }

        _ = query
        lastResults = results
        return results
    }

    // MARK: - Errors

    enum SearchError: LocalizedError {
        case noActiveProvider
        case requestFailed(String)

        var errorDescription: String? {
            switch self {
            case .noActiveProvider:
                return "No active search provider configured."
            case .requestFailed(let reason):
                return "Search request failed: \(reason)"
            }
        }
    }

    // MARK: - Private

    private func persistProviders() {
        guard let data = try? JSONEncoder().encode(searchProviders) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }
}
