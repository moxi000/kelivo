import SwiftUI
import SwiftData

// MARK: - QuickPhraseMenuView

/// A popup menu for selecting quick phrases to insert into chat input.
struct QuickPhraseMenuView: View {
    let onSelect: (String) -> Void

    @Query(
        filter: #Predicate<QuickPhrase> { $0.isEnabled },
        sort: \QuickPhrase.sortOrder
    )
    private var phrases: [QuickPhrase]

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    // MARK: Body

    var body: some View {
        NavigationStack {
            Group {
                if filteredPhrases.isEmpty {
                    emptyState
                } else {
                    phraseList
                }
            }
            .searchable(
                text: $searchText,
                prompt: String(localized: "searchPhrases")
            )
            .navigationTitle(String(localized: "quickPhrases"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "cancel")) {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Phrase List

    private var phraseList: some View {
        List(filteredPhrases) { phrase in
            Button {
                onSelect(phrase.content)
                dismiss()
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(phrase.title)
                        .font(.headline)

                    Text(phrase.content)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView(
            String(localized: "noQuickPhrases"),
            systemImage: "text.quote",
            description: Text(String(localized: "noQuickPhrasesDescription"))
        )
    }

    // MARK: - Filtering

    private var filteredPhrases: [QuickPhrase] {
        guard !searchText.isEmpty else { return phrases }
        return phrases.filter { phrase in
            phrase.title.localizedCaseInsensitiveContains(searchText)
                || phrase.content.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Preview

#Preview {
    QuickPhraseMenuView { selectedText in
        print("Selected: \(selectedText)")
    }
    .modelContainer(for: QuickPhrase.self, inMemory: true)
}
