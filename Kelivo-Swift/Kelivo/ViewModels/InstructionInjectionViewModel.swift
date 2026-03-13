import Foundation
import Observation
import SwiftData

@Observable
final class InstructionInjectionViewModel {

    // MARK: - Nested Types

    struct InstructionInjectionGroup: Identifiable, Codable, Sendable {
        var id: String
        var name: String
        var isEnabled: Bool
        var sortOrder: Int

        init(
            id: String = UUID().uuidString,
            name: String,
            isEnabled: Bool = true,
            sortOrder: Int = 0
        ) {
            self.id = id
            self.name = name
            self.isEnabled = isEnabled
            self.sortOrder = sortOrder
        }
    }

    // MARK: Published State

    var injections: [InstructionInjection] = []
    var groups: [InstructionInjectionGroup] = []

    // MARK: Private

    private var modelContext: ModelContext?

    private static let groupsStorageKey = "instructionInjection.groups"

    // MARK: Configuration

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Loading

    func loadInjections() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<InstructionInjection>(
            sortBy: [SortDescriptor(\.sortOrder, order: .forward)]
        )

        do {
            injections = try context.fetch(descriptor)
        } catch {
            injections = []
        }

        loadGroups()
    }

    // MARK: - Injection CRUD

    func addInjection(name: String, content: String, groupId: String = "") {
        let injection = InstructionInjection(
            name: name,
            content: content,
            groupId: groupId,
            sortOrder: injections.count
        )
        modelContext?.insert(injection)
        injections.append(injection)
        saveContext()
    }

    func updateInjection(_ injection: InstructionInjection) {
        saveContext()
    }

    func deleteInjection(_ injection: InstructionInjection) {
        guard let context = modelContext else { return }
        injections.removeAll { $0.id == injection.id }
        context.delete(injection)
        saveContext()
    }

    func getActiveInjections() -> [InstructionInjection] {
        let enabledGroupIds = Set(groups.filter(\.isEnabled).map(\.id))

        return injections.filter { injection in
            guard injection.isEnabled else { return false }
            // If the injection belongs to a group, check that the group is enabled
            if !injection.groupId.isEmpty {
                return enabledGroupIds.contains(injection.groupId)
            }
            // Ungrouped injections are active when individually enabled
            return true
        }
    }

    // MARK: - Group Management

    func addGroup(name: String) -> InstructionInjectionGroup {
        let group = InstructionInjectionGroup(
            name: name,
            sortOrder: groups.count
        )
        groups.append(group)
        persistGroups()
        return group
    }

    func deleteGroup(_ group: InstructionInjectionGroup) {
        groups.removeAll { $0.id == group.id }
        persistGroups()
    }

    func toggleGroup(_ group: InstructionInjectionGroup) {
        guard let index = groups.firstIndex(where: { $0.id == group.id }) else { return }
        groups[index].isEnabled.toggle()
        persistGroups()
    }

    // MARK: - Private

    private func loadGroups() {
        guard let data = UserDefaults.standard.data(forKey: Self.groupsStorageKey),
              let decoded = try? JSONDecoder().decode([InstructionInjectionGroup].self, from: data)
        else { return }

        groups = decoded
    }

    private func persistGroups() {
        guard let data = try? JSONEncoder().encode(groups) else { return }
        UserDefaults.standard.set(data, forKey: Self.groupsStorageKey)
    }

    private func saveContext() {
        guard let context = modelContext else { return }
        do {
            try context.save()
        } catch {
            // TODO: Surface save errors to the UI layer
        }
    }
}
