import Foundation
import Observation
import SwiftData

@Observable
final class WorldBookViewModel {

    // MARK: - Constants

    private static let activeIdsKey = "worldBook.activeIdsByAssistant"
    private static let collapsedKey = "worldBook.collapsedBooks"
    private static let globalKey = "__global__"

    // MARK: Published State

    var entries: [WorldBookEntry] = []
    var activeIdsByAssistant: [String: [String]] = [:]
    var collapsedBooks: Set<String> = []

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

        loadActiveIdsFromDefaults()
        loadCollapsedFromDefaults()
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
        let entryId = entry.id
        entries.removeAll { $0.id == entryId }
        context.delete(entry)
        saveContext()

        // Remove from active IDs across all assistants
        var changed = false
        for (key, ids) in activeIdsByAssistant {
            let filtered = ids.filter { $0 != entryId }
            if filtered.count != ids.count {
                activeIdsByAssistant[key] = filtered
                changed = true
            }
        }
        if changed {
            persistActiveIds()
        }

        // Remove from collapsed
        if collapsedBooks.remove(entryId) != nil {
            persistCollapsed()
        }
    }

    // MARK: - Assistant-Level Active IDs

    /// Returns active world book IDs for a given assistant.
    /// Falls back to global key if no assistant-specific mapping exists.
    func getActiveIds(for assistantId: String?) -> [String] {
        let key = Self.resolveAssistantKey(assistantId)
        if let ids = activeIdsByAssistant[key] {
            return ids
        }
        return activeIdsByAssistant[Self.globalKey] ?? []
    }

    /// Sets active world book IDs for a given assistant.
    func setActiveIds(_ ids: [String], for assistantId: String?) {
        let key = Self.resolveAssistantKey(assistantId)
        let cleaned = Self.cleanIds(ids)
        activeIdsByAssistant[key] = cleaned
        persistActiveIds()
    }

    /// Toggles the active state of a world book for a given assistant.
    func toggleActiveId(_ id: String, for assistantId: String?) {
        var current = Set(getActiveIds(for: assistantId))
        if current.contains(id) {
            current.remove(id)
        } else {
            // Only allow activating enabled entries
            guard let entry = entries.first(where: { $0.id == id }),
                  entry.isEnabled else {
                return
            }
            current.insert(id)
        }
        setActiveIds(Array(current), for: assistantId)
    }

    /// Checks if a world book is active for a given assistant.
    func isBookActive(_ id: String, for assistantId: String?) -> Bool {
        getActiveIds(for: assistantId).contains(id)
    }

    // MARK: - Collapsed State

    /// Returns whether a world book is collapsed in the UI.
    func isBookCollapsed(_ id: String) -> Bool {
        collapsedBooks.contains(id)
    }

    /// Toggles the collapsed state of a world book.
    func toggleBookCollapsed(_ id: String) {
        let trimmed = id.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        if collapsedBooks.contains(trimmed) {
            collapsedBooks.remove(trimmed)
        } else {
            collapsedBooks.insert(trimmed)
        }
        persistCollapsed()
    }

    /// Sets the collapsed state of a world book explicitly.
    func setBookCollapsed(_ id: String, collapsed: Bool) {
        let trimmed = id.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        if collapsed {
            collapsedBooks.insert(trimmed)
        } else {
            collapsedBooks.remove(trimmed)
        }
        persistCollapsed()
    }

    // MARK: - Reorder

    /// Reorders entries within a specific world book (by entry sortOrder).
    func reorderEntries(in bookId: String, from source: IndexSet, to destination: Int) {
        // Filter entries belonging to this "book" context, reorder, and update sortOrder.
        // Since SwiftData WorldBookEntry uses sortOrder for ordering,
        // we reorder the full entries array using IndexSet (SwiftUI List convention).
        var list = entries
        list.move(fromOffsets: source, toOffset: destination)

        // Update sortOrder to reflect new positions
        for (index, entry) in list.enumerated() {
            entry.sortOrder = index
        }
        entries = list
        saveContext()
    }

    // MARK: - Clear All

    /// Removes all entries and resets active/collapsed state.
    func clearAll() {
        guard let context = modelContext else { return }

        for entry in entries {
            context.delete(entry)
        }
        entries = []
        activeIdsByAssistant = [:]
        collapsedBooks = []
        saveContext()

        UserDefaults.standard.removeObject(forKey: Self.activeIdsKey)
        UserDefaults.standard.removeObject(forKey: Self.collapsedKey)
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

    // MARK: - Private Helpers

    private static func resolveAssistantKey(_ assistantId: String?) -> String {
        let id = (assistantId ?? "").trimmingCharacters(in: .whitespaces)
        return id.isEmpty ? globalKey : id
    }

    private static func cleanIds(_ ids: [String]) -> [String] {
        var seen = Set<String>()
        return ids.compactMap { raw in
            let trimmed = raw.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty, !seen.contains(trimmed) else { return nil }
            seen.insert(trimmed)
            return trimmed
        }
    }

    private func saveContext() {
        guard let context = modelContext else { return }
        do {
            try context.save()
        } catch {
            // TODO: Surface save errors to the UI layer
        }
    }

    // MARK: - UserDefaults Persistence

    private func loadActiveIdsFromDefaults() {
        guard let data = UserDefaults.standard.data(forKey: Self.activeIdsKey) else {
            activeIdsByAssistant = [:]
            return
        }
        do {
            let decoded = try JSONDecoder().decode([String: [String]].self, from: data)
            activeIdsByAssistant = decoded
        } catch {
            activeIdsByAssistant = [:]
        }
    }

    private func persistActiveIds() {
        do {
            let data = try JSONEncoder().encode(activeIdsByAssistant)
            UserDefaults.standard.set(data, forKey: Self.activeIdsKey)
        } catch {
            // Persistence failure is non-fatal; state remains in memory
        }
    }

    private func loadCollapsedFromDefaults() {
        guard let data = UserDefaults.standard.data(forKey: Self.collapsedKey) else {
            collapsedBooks = []
            return
        }
        do {
            let decoded = try JSONDecoder().decode(Set<String>.self, from: data)
            // Clean: only keep IDs that correspond to existing entries
            let knownIds = Set(entries.map(\.id))
            let cleaned = decoded.intersection(knownIds)
            collapsedBooks = cleaned
            if cleaned.count != decoded.count {
                persistCollapsed()
            }
        } catch {
            collapsedBooks = []
        }
    }

    private func persistCollapsed() {
        do {
            let data = try JSONEncoder().encode(collapsedBooks)
            UserDefaults.standard.set(data, forKey: Self.collapsedKey)
        } catch {
            // Persistence failure is non-fatal; state remains in memory
        }
    }
}
