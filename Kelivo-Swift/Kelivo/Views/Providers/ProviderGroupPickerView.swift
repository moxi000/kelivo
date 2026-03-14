import SwiftUI
import SwiftData

// MARK: - ProviderGroupPickerView

/// Allows the user to assign a provider to a group, or remove it from all groups.
/// Also supports creating a new group inline and navigating to the group manager.
/// Corresponds to Flutter: `lib/features/provider/widgets/provider_group_picker_sheet.dart`
struct ProviderGroupPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    /// The provider key whose group assignment is being changed.
    let providerKey: String

    @State private var groups: [ProviderGroup] = []
    @State private var currentGroupId: String?
    @State private var showNewGroupAlert = false
    @State private var newGroupName = ""

    var body: some View {
        NavigationStack {
            List {
                // "Ungrouped" option
                Section {
                    ungroupedRow

                    ForEach(groups) { group in
                        groupRow(group)
                    }
                } header: {
                    Text(String(localized: "Groups"))
                }
            }
            .navigationTitle(String(localized: "Select Group"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }

                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        showNewGroupAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }

                    NavigationLink {
                        ProviderGroupsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .alert(String(localized: "New Group"), isPresented: $showNewGroupAlert) {
                TextField(String(localized: "Group Name"), text: $newGroupName)
                Button(String(localized: "Cancel"), role: .cancel) {
                    newGroupName = ""
                }
                Button(String(localized: "Create")) {
                    createAndAssign()
                }
                .disabled(newGroupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .onAppear(perform: loadState)
        }
        .presentationDetents([.medium])
    }

    // MARK: - Rows

    private var ungroupedRow: some View {
        Button {
            assignGroup(nil)
        } label: {
            HStack {
                Label(String(localized: "Ungrouped"), systemImage: "tray")
                    .foregroundStyle(.primary)
                Spacer()
                if currentGroupId == nil {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.tint)
                        .font(.body.weight(.semibold))
                }
            }
        }
    }

    private func groupRow(_ group: ProviderGroup) -> some View {
        let isSelected = currentGroupId == group.id

        return Button {
            assignGroup(group.id)
        } label: {
            HStack {
                Label(group.name, systemImage: "folder.fill")
                    .foregroundStyle(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.tint)
                        .font(.body.weight(.semibold))
                }
            }
        }
    }

    // MARK: - Actions

    private func loadState() {
        // In production, load groups from UserDefaults/SwiftData and
        // read the current provider's groupId.
    }

    private func assignGroup(_ groupId: String?) {
        currentGroupId = groupId
        persistAssignment()
        dismiss()
    }

    private func createAndAssign() {
        let name = newGroupName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        let group = ProviderGroup(name: name)
        groups.append(group)
        newGroupName = ""
        assignGroup(group.id)
    }

    private func persistAssignment() {
        // In production, update the provider's groupId via modelContext
        // or a settings service.
    }
}

#Preview {
    ProviderGroupPickerView(providerKey: "preview-provider-key")
}
