import SwiftUI
import SwiftData

struct InstructionInjectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \InstructionInjection.sortOrder) private var injections: [InstructionInjection]

    @State private var showAddInjection = false
    @State private var editingInjection: InstructionInjection?

    /// Group injections by their groupId.
    private var groupedInjections: [(String, [InstructionInjection])] {
        let dict = Dictionary(grouping: injections) { $0.groupId.isEmpty ? String(localized: "Ungrouped") : $0.groupId }
        return dict.sorted { $0.key < $1.key }
    }

    var body: some View {
        List {
            ForEach(groupedInjections, id: \.0) { group, items in
                Section {
                    ForEach(items) { injection in
                        Button {
                            editingInjection = injection
                        } label: {
                            injectionRow(injection)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { offsets in
                        deleteInjections(items: items, offsets: offsets)
                    }
                } header: {
                    Text(group)
                }
            }
        }
        .navigationTitle(String(localized: "Instruction Injection"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddInjection = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddInjection) {
            InjectionEditorSheet(injection: nil)
        }
        .sheet(item: $editingInjection) { injection in
            InjectionEditorSheet(injection: injection)
        }
        .overlay {
            if injections.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Injections"), systemImage: "syringe")
                } description: {
                    Text(String(localized: "Add instruction injections to modify how messages are sent to the model."))
                }
            }
        }
    }

    // MARK: - Row

    private func injectionRow(_ injection: InstructionInjection) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(injection.name)
                    .font(.body)
                Text(injection.content)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { injection.isEnabled },
                set: { injection.isEnabled = $0 }
            ))
            .labelsHidden()
        }
    }

    // MARK: - Actions

    private func deleteInjections(items: [InstructionInjection], offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

// MARK: - Editor Sheet

private struct InjectionEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let injection: InstructionInjection?

    @State private var name = ""
    @State private var content = ""
    @State private var groupId = ""
    @State private var isEnabled = true

    private var isNew: Bool { injection == nil }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(String(localized: "Name"), text: $name)
                    TextField(String(localized: "Group"), text: $groupId)
                    Toggle(String(localized: "Enabled"), isOn: $isEnabled)
                } header: {
                    Text(String(localized: "Details"))
                }

                Section {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                } header: {
                    Text(String(localized: "Injection Content"))
                } footer: {
                    Text(String(localized: "This text will be injected into the conversation context."))
                }
            }
            .formStyle(.grouped)
            .navigationTitle(isNew ? String(localized: "New Injection") : String(localized: "Edit Injection"))
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
                if let injection {
                    name = injection.name
                    content = injection.content
                    groupId = injection.groupId
                    isEnabled = injection.isEnabled
                }
            }
        }
    }

    private func save() {
        if let injection {
            injection.name = name
            injection.content = content
            injection.groupId = groupId
            injection.isEnabled = isEnabled
        } else {
            let newInjection = InstructionInjection(
                name: name,
                content: content,
                isEnabled: isEnabled,
                groupId: groupId
            )
            modelContext.insert(newInjection)
        }
    }
}

#Preview {
    NavigationStack {
        InstructionInjectionView()
    }
}
