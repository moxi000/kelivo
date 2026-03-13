import SwiftUI
import SwiftData

@available(iOS 26.0, macOS 26.0, *)
struct WorldBookView: View {
    @Environment(WorldBookViewModel.self) private var worldBookVM
    @State private var showAddSheet = false
    @State private var newKeyword = ""
    @State private var newContent = ""
    @State private var newMatchWholeWord = false
    @State private var newCaseSensitive = false
    @State private var searchText = ""

    private var filteredEntries: [WorldBookEntry] {
        if searchText.isEmpty { return worldBookVM.entries }
        return worldBookVM.entries.filter {
            $0.keyword.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            ForEach(filteredEntries) { entry in
                NavigationLink {
                    WorldBookEntryEditView(entry: entry)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Text(entry.keyword)
                                    .font(.headline)
                                if entry.matchWholeWord {
                                    Text("W")
                                        .font(.caption2)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 1)
                                        .background(.blue.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }
                                if entry.caseSensitive {
                                    Text("Aa")
                                        .font(.caption2)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 1)
                                        .background(.orange.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }
                            }
                            Text(entry.content)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { entry.isEnabled },
                            set: { newValue in
                                entry.isEnabled = newValue
                                worldBookVM.updateEntry(entry)
                            }
                        ))
                        .labelsHidden()
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    worldBookVM.deleteEntry(filteredEntries[index])
                }
            }
        }
        .searchable(text: $searchText, prompt: String(localized: "searchWorldBook"))
        .navigationTitle(String(localized: "worldBook"))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.glass)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            NavigationStack {
                Form {
                    TextField(String(localized: "keyword"), text: $newKeyword)
                    Section(String(localized: "content")) {
                        TextEditor(text: $newContent)
                            .frame(minHeight: 150)
                    }
                    Section(String(localized: "matchOptions")) {
                        Toggle(String(localized: "matchWholeWord"), isOn: $newMatchWholeWord)
                        Toggle(String(localized: "caseSensitive"), isOn: $newCaseSensitive)
                    }
                }
                .navigationTitle(String(localized: "addWorldBookEntry"))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "cancel")) { showAddSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(String(localized: "save")) {
                            worldBookVM.addEntry(keyword: newKeyword, content: newContent)
                            newKeyword = ""
                            newContent = ""
                            showAddSheet = false
                        }
                        .disabled(newKeyword.isEmpty || newContent.isEmpty)
                    }
                }
            }
        }
    }
}

@available(iOS 26.0, macOS 26.0, *)
private struct WorldBookEntryEditView: View {
    @Bindable var entry: WorldBookEntry
    @Environment(WorldBookViewModel.self) private var worldBookVM

    var body: some View {
        Form {
            TextField(String(localized: "keyword"), text: $entry.keyword)
            Toggle(String(localized: "enabled"), isOn: $entry.isEnabled)
            Toggle(String(localized: "matchWholeWord"), isOn: $entry.matchWholeWord)
            Toggle(String(localized: "caseSensitive"), isOn: $entry.caseSensitive)
            Section(String(localized: "content")) {
                TextEditor(text: $entry.content)
                    .frame(minHeight: 200)
            }
        }
        .navigationTitle(entry.keyword)
    }
}
