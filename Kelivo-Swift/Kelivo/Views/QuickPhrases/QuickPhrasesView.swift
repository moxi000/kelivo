import SwiftUI
import SwiftData

struct QuickPhrasesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \QuickPhrase.sortOrder) private var allPhrases: [QuickPhrase]

    /// If set, only show phrases for this assistant; otherwise show global phrases.
    var assistantId: String? = nil

    @State private var showAddPhrase = false
    @State private var editingPhrase: QuickPhrase?

    private var phrases: [QuickPhrase] {
        if let assistantId {
            return allPhrases.filter { $0.assistantId == assistantId || $0.isGlobal }
        }
        return allPhrases.filter(\.isGlobal)
    }

    var body: some View {
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
        .navigationTitle(String(localized: "Quick Phrases"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { EditButton() }
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddPhrase = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddPhrase) {
            phraseEditor(phrase: nil)
        }
        .sheet(item: $editingPhrase) { phrase in
            phraseEditor(phrase: phrase)
        }
        .overlay {
            if phrases.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Quick Phrases"), systemImage: "text.bubble")
                } description: {
                    Text(String(localized: "Add quick phrases for frequently used messages."))
                }
            }
        }
    }

    // MARK: - Row

    private func phraseRow(_ phrase: QuickPhrase) -> some View {
        GlassCard(cornerRadius: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(phrase.title)
                        .font(.headline)
                    Text(phrase.content)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                if !phrase.isEnabled {
                    Image(systemName: "eye.slash")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .listRowSeparator(.hidden)
    }

    // MARK: - Editor Sheet

    private func phraseEditor(phrase: QuickPhrase?) -> some View {
        QuickPhraseEditorSheet(
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

// MARK: - Editor Sheet

private struct QuickPhraseEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let phrase: QuickPhrase?
    let assistantId: String?

    @State private var title = ""
    @State private var content = ""
    @State private var isEnabled = true

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
                } header: {
                    Text(String(localized: "Content"))
                }

                Section {
                    Toggle(String(localized: "Enabled"), isOn: $isEnabled)
                }
            }
            .formStyle(.grouped)
            .navigationTitle(isNew ? String(localized: "New Phrase") : String(localized: "Edit Phrase"))
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
                    isEnabled = phrase.isEnabled
                }
            }
        }
    }

    private func save() {
        if let phrase {
            phrase.title = title
            phrase.content = content
            phrase.isEnabled = isEnabled
        } else {
            let newPhrase = QuickPhrase(
                title: title,
                content: content,
                isEnabled: isEnabled,
                isGlobal: assistantId == nil,
                assistantId: assistantId
            )
            modelContext.insert(newPhrase)
        }
    }
}

#Preview {
    NavigationStack {
        QuickPhrasesView()
    }
}
