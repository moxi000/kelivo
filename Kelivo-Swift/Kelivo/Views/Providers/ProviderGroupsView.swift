import SwiftUI
import SwiftData

struct ProviderGroupsView: View {
    @Query(sort: \ProviderConfig.sortOrder) private var providers: [ProviderConfig]

    @State private var groups: [ProviderGroup] = []
    @State private var showAddGroup = false
    @State private var newGroupName = ""
    @State private var editingGroup: ProviderGroup?
    @State private var editGroupName = ""

    var body: some View {
        List {
            if groups.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Groups"), systemImage: "folder")
                } description: {
                    Text(String(localized: "Create groups to organize your providers."))
                } actions: {
                    Button {
                        showAddGroup = true
                    } label: {
                        Text(String(localized: "Add Group"))
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                ForEach(groups) { group in
                    groupRow(group)
                }
                .onDelete(perform: deleteGroups)
                .onMove(perform: moveGroups)
            }
        }
        .navigationTitle(String(localized: "Provider Groups"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddGroup = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .alert(String(localized: "New Group"), isPresented: $showAddGroup) {
            TextField(String(localized: "Group Name"), text: $newGroupName)
            Button(String(localized: "Cancel"), role: .cancel) {
                newGroupName = ""
            }
            Button(String(localized: "Add")) {
                addGroup()
            }
            .disabled(newGroupName.isEmpty)
        }
        .alert(String(localized: "Rename Group"), isPresented: .init(
            get: { editingGroup != nil },
            set: { if !$0 { editingGroup = nil } }
        )) {
            TextField(String(localized: "Group Name"), text: $editGroupName)
            Button(String(localized: "Cancel"), role: .cancel) {
                editingGroup = nil
                editGroupName = ""
            }
            Button(String(localized: "Save")) {
                renameGroup()
            }
            .disabled(editGroupName.isEmpty)
        }
    }

    // MARK: - Row

    private func groupRow(_ group: ProviderGroup) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "folder.fill")
                .foregroundStyle(.tint)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(group.name)
                    .font(.body)
                Text(String(localized: "\(providerCount(for: group)) providers"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 2)
        .contextMenu {
            Button {
                editingGroup = group
                editGroupName = group.name
            } label: {
                Label(String(localized: "Rename"), systemImage: "pencil")
            }

            Button(role: .destructive) {
                groups.removeAll { $0.id == group.id }
            } label: {
                Label(String(localized: "Delete"), systemImage: "trash")
            }
        }
    }

    // MARK: - Actions

    private func addGroup() {
        let group = ProviderGroup(name: newGroupName)
        groups.append(group)
        newGroupName = ""
    }

    private func renameGroup() {
        guard let editing = editingGroup,
              let index = groups.firstIndex(where: { $0.id == editing.id }) else { return }
        groups[index] = groups[index].copyWith(name: editGroupName)
        editingGroup = nil
        editGroupName = ""
    }

    private func deleteGroups(at offsets: IndexSet) {
        groups.remove(atOffsets: offsets)
    }

    private func moveGroups(from source: IndexSet, to destination: Int) {
        groups.move(fromOffsets: source, toOffset: destination)
    }

    // MARK: - Helpers

    private func providerCount(for group: ProviderGroup) -> Int {
        providers.filter { $0.groupId == group.id }.count
    }
}

#Preview {
    NavigationStack {
        ProviderGroupsView()
    }
}
