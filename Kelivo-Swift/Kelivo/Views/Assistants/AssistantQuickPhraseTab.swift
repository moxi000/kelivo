import SwiftUI
import SwiftData

// MARK: - AssistantQuickPhraseTab

/// Tab view for managing quick phrases within an assistant's edit view.
/// Supports adding, editing, deleting, and reordering quick phrases.
/// Corresponds to Flutter: `lib/features/assistant/pages/assistant_settings_edit_quick_phrase_tab.dart`
struct AssistantQuickPhraseTab: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \QuickPhrase.sortOrder) private var allPhrases: [QuickPhrase]

    /// The assistant this tab belongs to.
    let assistantId: String

    @State private var showAddSheet = false
    @State private var editingPhrase: QuickPhrase?

    private var phrases: [QuickPhrase] {
        allPhrases.filter { $0.assistantId == assistantId }
    }

    var body: some View {
        Group {
            if phrases.isEmpty {
                emptyState
            } else {
                phraseList
            }
        }
        .sheet(isPresented: $showAddSheet) {
            phraseEditor(phrase: nil)
        }
        .sheet(item: $editingPhrase) { phrase in
            phraseEditor(phrase: phrase)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView {
            Label(String(localized: "No Quick Phrases"), systemImage: "bolt")
        } description: {
            Text(String(localized: "Add quick phrases for frequently used messages with this assistant."))
        } actions: {
            Button {
                showAddSheet = true
            } label: {
                Label(String(localized: "Add Quick Phrase"), systemImage: "plus")
            }
            .applyGlassProminent()
        }
    }

    // MARK: - Phrase List

    private var phraseList: some View {
        List {
            ForEach(phrases) { phrase in
                Button {
                    editingPhrase = phrase
                } label: {
                    phraseRow(phrase)
                }
                .buttonStyle(.plain)
            }
            .onDelete(perform: deletePhrases)
            .onMove(perform: movePhrases)
        }
        #if os(iOS)
        .toolbar { EditButton() }
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    // MARK: - Row

    private func phraseRow(_ phrase: QuickPhrase) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "text.bubble")
                .font(.body)
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 4) {
                Text(phrase.title)
                    .font(.body.weight(.semibold))
                    .lineLimit(1)

                Text(phrase.content)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }

    // MARK: - Editor

    private func phraseEditor(phrase: QuickPhrase?) -> some View {
        QuickPhraseEditSheet(
            phrase: phrase,
            assistantId: assistantId
        )
    }

    // MARK: - Actions

    private func deletePhrases(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(phrases[index])
        }
    }

    private func movePhrases(from source: IndexSet, to destination: Int) {
        var ordered = phrases
        ordered.move(fromOffsets: source, toOffset: destination)
        for (index, phrase) in ordered.enumerated() {
            phrase.sortOrder = index
        }
    }
}

// MARK: - Edit Sheet

private struct QuickPhraseEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let phrase: QuickPhrase?
    let assistantId: String

    @State private var title = ""
    @State private var content = ""

    private var isNew: Bool { phrase == nil }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(String(localized: "Title"), text: $title)
                } header: {
                    Text(String(localized: "Title"))
                }

                Section {
                    TextEditor(text: $content)
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
                } header: {
                    Text(String(localized: "Content"))
                }
            }
            .formStyle(.grouped)
            .navigationTitle(
                isNew
                    ? String(localized: "New Phrase")
                    : String(localized: "Edit Phrase")
            )
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save")) {
                        save()
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .onAppear {
                if let phrase {
                    title = phrase.title
                    content = phrase.content
                }
            }
        }
    }

    // MARK: - Save

    private func save() {
        if let phrase {
            phrase.title = title
            phrase.content = content
        } else {
            let newPhrase = QuickPhrase(
                title: title,
                content: content,
                isEnabled: true,
                isGlobal: false,
                assistantId: assistantId
            )
            modelContext.insert(newPhrase)
        }
    }
}

// MARK: - Glass Style

private extension View {
    @ViewBuilder
    func applyGlassProminent() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigationStack {
        AssistantQuickPhraseTab(assistantId: "preview-assistant-id")
    }
}
