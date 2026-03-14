import SwiftUI
import SwiftData

struct AssistantMemoryTab: View {
    @Environment(\.modelContext) private var modelContext

    let assistantId: String?
    @Binding var enableMemory: Bool

    @Query private var memories: [AssistantMemory]
    @State private var showAddMemory = false
    @State private var newMemoryContent = ""
    @State private var editingMemory: AssistantMemory?

    /// Filter memories for the current assistant.
    private var filteredMemories: [AssistantMemory] {
        guard let assistantId else { return [] }
        return memories.filter { $0.assistantId == assistantId }
    }

    var body: some View {
        Form {
            // MARK: - Toggle
            Section {
                Toggle(String(localized: "Enable Memory"), isOn: $enableMemory)
            } header: {
                Text(String(localized: "Memory"))
            } footer: {
                Text(String(localized: "When enabled, the assistant will remember information across conversations."))
            }

            // MARK: - Memory Entries
            if enableMemory, assistantId != nil {
                Section {
                    ForEach(filteredMemories) { memory in
                        Button {
                            editingMemory = memory
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(memory.content)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .lineLimit(3)

                                Text(memory.createdAt, style: .date)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { offsets in
                        deleteMemories(at: offsets)
                    }

                    Button {
                        showAddMemory = true
                    } label: {
                        Label(String(localized: "Add Memory"), systemImage: "plus.circle")
                    }
                } header: {
                    Text(String(localized: "Memories (\(filteredMemories.count))"))
                }
            }

            if enableMemory && assistantId == nil {
                Section {
                    ContentUnavailableView {
                        Label(String(localized: "Save First"), systemImage: "brain")
                    } description: {
                        Text(String(localized: "Save the assistant first to manage memories."))
                    }
                }
            }
        }
        .formStyle(.grouped)
        .alert(String(localized: "Add Memory"), isPresented: $showAddMemory) {
            TextField(String(localized: "Memory content"), text: $newMemoryContent)
            Button(String(localized: "Cancel"), role: .cancel) {
                newMemoryContent = ""
            }
            Button(String(localized: "Add")) {
                addMemory()
            }
        }
        .sheet(item: $editingMemory) { memory in
            NavigationStack {
                MemoryEditSheet(memory: memory)
            }
        }
    }

    // MARK: - Actions

    private func addMemory() {
        guard let assistantId, !newMemoryContent.isEmpty else { return }
        let memory = AssistantMemory(
            assistantId: assistantId,
            content: newMemoryContent
        )
        modelContext.insert(memory)
        newMemoryContent = ""
    }

    private func deleteMemories(at offsets: IndexSet) {
        for index in offsets {
            let memory = filteredMemories[index]
            modelContext.delete(memory)
        }
    }
}

// MARK: - Memory Edit Sheet

private struct MemoryEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var memory: AssistantMemory

    var body: some View {
        Form {
            Section {
                TextEditor(text: $memory.content)
                    .font(.body)
                    .frame(minHeight: 120)
                    .scrollContentBackground(.hidden)
                    .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
            } header: {
                Text(String(localized: "Content"))
            }

            Section {
                LabeledContent(String(localized: "Created"), value: memory.createdAt, format: .dateTime)
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Edit Memory"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Done")) { dismiss() }
            }
        }
    }
}

#Preview {
    AssistantMemoryTab(assistantId: nil, enableMemory: .constant(true))
}
