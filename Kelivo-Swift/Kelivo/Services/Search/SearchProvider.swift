import Foundation

// MARK: - Search Result

struct SearchResult: Sendable, Codable {
    let title: String
    let url: String
    let snippet: String
    let content: String?
}

// MARK: - Search Error

enum SearchError: Error, LocalizedError {
    case invalidConfiguration(String)
    case requestFailed(underlying: Error)
    case parseFailed(String)
    case noResults

    var errorDescription: String? {
        switch self {
        case let .invalidConfiguration(detail):
            return "Search configuration error: \(detail)"
        case let .requestFailed(underlying):
            return "Search request failed: \(underlying.localizedDescription)"
        case let .parseFailed(detail):
            return "Failed to parse search results: \(detail)"
        case .noResults:
            return "No search results found"
        }
    }
}

// MARK: - Search Provider Protocol

protocol SearchProvider: Sendable {
    var id: String { get }
    var name: String { get }
    func search(query: String, maxResults: Int) async throws -> [SearchResult]
}
