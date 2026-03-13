import Foundation
import Observation
import SwiftData

@Observable
final class QuickPhraseViewModel {

    // MARK: Published State

    var phrases: [QuickPhrase] = []

    // MARK: Private

    private var modelContext: ModelContext?

    // MARK: Configuration

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Loading

    func loadPhrases() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<QuickPhrase>(
            sortBy: [SortDescriptor(\.sortOrder, order: .forward)]
        )

        do {
            phrases = try context.fetch(descriptor)
        } catch {
            phrases = []
        }
    }

    // MARK: - CRUD

    func addPhrase(title: String, content: String) {
        let phrase = QuickPhrase(
            title: title,
            content: content,
            sortOrder: phrases.count
        )
        modelContext?.insert(phrase)
        phrases.append(phrase)
        saveContext()
    }

    func updatePhrase(_ phrase: QuickPhrase) {
        saveContext()
    }

    func deletePhrase(_ phrase: QuickPhrase) {
        guard let context = modelContext else { return }
        phrases.removeAll { $0.id == phrase.id }
        context.delete(phrase)
        saveContext()
    }

    func reorder(from source: IndexSet, to destination: Int) {
        phrases.move(fromOffsets: source, toOffset: destination)

        // Update sort orders to reflect new positions
        for (index, phrase) in phrases.enumerated() {
            phrase.sortOrder = index
        }

        saveContext()
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
