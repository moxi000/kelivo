import SwiftUI
import SwiftData

struct WorldBookView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorldBookEntry.sortOrder) private var entries: [WorldBookEntry]

    @State private var searchText = ""
    @State private var showAddEntry = false
    @State private var editingEntry: WorldBookEntry?

    private var filteredEntries: [WorldBookEntry] {
        guard !searchText.isEmpty else { return entries }
        return entries.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText) ||
            $0.keywords.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
        }
    }

    var body: some View {
        List {
            ForEach(filteredEntries) { entry in
                Button {
                    editingEntry = entry
                } label: {
                    entryRow(entry)
                }
                .buttonStyle(.plain)
            }
            .onDelete(perform: deleteEntries)
        }
        .searchable(text: $searchText, prompt: String(localized: "Search entries"))
        .navigationTitle(String(localized: "World Book"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddEntry = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddEntry) {
            WorldBookEditorSheet(entry: nil)
        }
        .sheet(item: $editingEntry) { entry in
            WorldBookEditorSheet(entry: entry)
        }
        .overlay {
            if entries.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Entries"), systemImage: "book.closed")
                } description: {
                    Text(String(localized: "Add world book entries to provide contextual knowledge to your assistants."))
                }
            }
        }
    }

    // MARK: - Row

    private func entryRow(_ entry: WorldBookEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(entry.name)
                        .font(.body)
                    if entry.constantActive {
                        Image(systemName: "pin.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }

                if !entry.keywords.isEmpty {
                    Text(entry.keywords.joined(separator: ", "))
                        .font(.caption.italic())
                        .foregroundStyle(.tint)
                        .lineLimit(1)
                }

                Text(entry.content)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { entry.isEnabled },
                set: { entry.isEnabled = $0 }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 2)
    }

    // MARK: - Actions

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredEntries[index])
        }
    }
}

// MARK: - Editor Sheet

private struct WorldBookEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let entry: WorldBookEntry?

    @State private var name = ""
    @State private var content = ""
    @State private var keywordsText = ""
    @State private var isEnabled = true
    @State private var constantActive = false
    @State private var useRegex = false
    @State private var caseSensitive = false
    @State private var position: WorldBookInjectionPosition = .afterSystemPrompt
    @State private var priority = 0
    @State private var scanDepth = 4

    private var isNew: Bool { entry == nil }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(String(localized: "Entry Name"), text: $name)
                    Toggle(String(localized: "Enabled"), isOn: $isEnabled)
                    Toggle(String(localized: "Always Active"), isOn: $constantActive)
                } header: {
                    Text(String(localized: "Basic"))
                }

                Section {
                    TextField(String(localized: "Keywords (comma-separated)"), text: $keywordsText)
                        .autocorrectionDisabled()
                    Toggle(String(localized: "Use Regex"), isOn: $useRegex)
                    Toggle(String(localized: "Case Sensitive"), isOn: $caseSensitive)
                    Stepper(String(localized: "Scan Depth: \(scanDepth)"), value: $scanDepth, in: 1...20)
                } header: {
                    Text(String(localized: "Matching"))
                }

                Section {
                    Picker(String(localized: "Position"), selection: $position) {
                        Text(String(localized: "Before System Prompt")).tag(WorldBookInjectionPosition.beforeSystemPrompt)
                        Text(String(localized: "After System Prompt")).tag(WorldBookInjectionPosition.afterSystemPrompt)
                        Text(String(localized: "Top of Chat")).tag(WorldBookInjectionPosition.topOfChat)
                        Text(String(localized: "Bottom of Chat")).tag(WorldBookInjectionPosition.bottomOfChat)
                        Text(String(localized: "At Depth")).tag(WorldBookInjectionPosition.atDepth)
                    }
                    Stepper(String(localized: "Priority: \(priority)"), value: $priority, in: 0...100)
                } header: {
                    Text(String(localized: "Injection"))
                }

                Section {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                } header: {
                    Text(String(localized: "Content"))
                }
            }
            .formStyle(.grouped)
            .navigationTitle(isNew ? String(localized: "New Entry") : String(localized: "Edit Entry"))
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
                    .disabled(name.isEmpty)
                }
            }
            .onAppear {
                if let entry {
                    name = entry.name
                    content = entry.content
                    keywordsText = entry.keywords.joined(separator: ", ")
                    isEnabled = entry.isEnabled
                    constantActive = entry.constantActive
                    useRegex = entry.useRegex
                    caseSensitive = entry.caseSensitive
                    position = entry.position
                    priority = entry.priority
                    scanDepth = entry.scanDepth
                }
            }
        }
    }

    private func save() {
        let keywords = keywordsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        if let entry {
            entry.name = name
            entry.content = content
            entry.keywords = keywords
            entry.isEnabled = isEnabled
            entry.constantActive = constantActive
            entry.useRegex = useRegex
            entry.caseSensitive = caseSensitive
            entry.position = position
            entry.priority = priority
            entry.scanDepth = scanDepth
        } else {
            let newEntry = WorldBookEntry(
                name: name,
                isEnabled: isEnabled,
                priority: priority,
                position: position,
                content: content,
                keywords: keywords,
                useRegex: useRegex,
                caseSensitive: caseSensitive,
                scanDepth: scanDepth,
                constantActive: constantActive
            )
            modelContext.insert(newEntry)
        }
    }
}

#Preview {
    NavigationStack {
        WorldBookView()
    }
}
