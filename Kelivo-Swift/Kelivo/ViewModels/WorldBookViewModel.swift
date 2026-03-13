import Foundation
import Observation
import SwiftData

@Observable
final class WorldBookViewModel {

    // MARK: Published State

    var entries: [WorldBookEntry] = []

    // MARK: Private

    private var modelContext: ModelContext?

    // MARK: Configuration

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Loading

    func loadEntries() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<WorldBookEntry>(
            sortBy: [SortDescriptor(\.sortOrder, order: .forward)]
        )

        do {
            entries = try context.fetch(descriptor)
        } catch {
            entries = []
        }
    }

    // MARK: - CRUD

    func addEntry(keyword: String, content: String) {
        let entry = WorldBookEntry(
            keywords: [keyword],
            content: content,
            sortOrder: entries.count
        )
        modelContext?.insert(entry)
        entries.append(entry)
        saveContext()
    }

    func updateEntry(_ entry: WorldBookEntry) {
        saveContext()
    }

    func deleteEntry(_ entry: WorldBookEntry) {
        guard let context = modelContext else { return }
        entries.removeAll { $0.id == entry.id }
        context.delete(entry)
        saveContext()
    }

    // MARK: - Matching

    /// Returns all enabled entries whose keywords match the given text.
    /// Respects each entry's `useRegex`, `caseSensitive`, and `constantActive` flags.
    func matchEntries(for text: String) -> [WorldBookEntry] {
        let activeEntries = entries.filter(\.isEnabled)

        return activeEntries.filter { entry in
            // Constant-active entries always match
            if entry.constantActive { return true }

            for keyword in entry.keywords {
                guard !keyword.isEmpty else { continue }

                if entry.useRegex {
                    var options: NSRegularExpression.Options = []
                    if !entry.caseSensitive {
                        options.insert(.caseInsensitive)
                    }

                    if let regex = try? NSRegularExpression(pattern: keyword, options: options) {
                        let range = NSRange(text.startIndex..., in: text)
                        if regex.firstMatch(in: text, range: range) != nil {
                            return true
                        }
                    }
                } else {
                    let compareOptions: String.CompareOptions = entry.caseSensitive
                        ? [] : [.caseInsensitive]
                    if text.range(of: keyword, options: compareOptions) != nil {
                        return true
                    }
                }
            }

            return false
        }
        .sorted { $0.priority > $1.priority }
    }

    // MARK: - Private

    private func saveContext() {
        guard let context = modelContext else { return }
        do {
            try context.save()
        } catch {
            // TODO: Surface save errors to the UI layer
        }
    }
}
