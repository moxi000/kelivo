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
    var collapsedGroups: Set<String> = []

    // MARK: Private

    private var modelContext: ModelContext?

    private static let groupsStorageKey = "instructionInjection.groups"
    private static let collapsedGroupsStorageKey = "instructionInjection.collapsedGroups"
    private static let activeIdsByAssistantKey = "instructionInjection.activeIdsByAssistant"
    private static let globalKey = "__global__"

    /// Per-assistant active injection IDs. Key is assistant ID or `globalKey` for the default.
    var activeIdsByAssistant: [String: [String]] = [:]

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
        loadCollapsedGroups()
        loadActiveIdsByAssistant()
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

    // MARK: - Batch Operations

    func addMany(_ newInjections: [InstructionInjection]) {
        guard let context = modelContext else { return }
        let startOrder = injections.count
        for (offset, injection) in newInjections.enumerated() {
            injection.sortOrder = startOrder + offset
            context.insert(injection)
            injections.append(injection)
        }
        saveContext()
    }

    func clearAll() {
        guard let context = modelContext else { return }
        for injection in injections {
            context.delete(injection)
        }
        injections.removeAll()
        saveContext()
    }

    // MARK: - Reorder

    func reorder(from source: IndexSet, to destination: Int) {
        injections.move(fromOffsets: source, toOffset: destination)
        for (index, injection) in injections.enumerated() {
            injection.sortOrder = index
        }
        saveContext()
    }

    // MARK: - Per-Assistant Active IDs

    func getActiveIds(for assistantId: String?) -> [String] {
        let key = assistantId ?? Self.globalKey
        if let ids = activeIdsByAssistant[key] {
            return ids
        }
        // Fall back to global list when no per-assistant override exists
        return activeIdsByAssistant[Self.globalKey] ?? []
    }

    func setActiveIds(_ ids: [String], for assistantId: String?) {
        let key = assistantId ?? Self.globalKey
        activeIdsByAssistant[key] = ids
        persistActiveIdsByAssistant()
    }

    func toggleActiveId(_ id: String, for assistantId: String?) {
        var ids = Set(getActiveIds(for: assistantId))
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        setActiveIds(Array(ids), for: assistantId)
    }

    // MARK: - Group Collapse State

    func toggleGroupCollapsed(_ groupId: String) {
        if collapsedGroups.contains(groupId) {
            collapsedGroups.remove(groupId)
        } else {
            collapsedGroups.insert(groupId)
        }
        persistCollapsedGroups()
    }

    func isGroupCollapsed(_ groupId: String) -> Bool {
        collapsedGroups.contains(groupId)
    }

    // MARK: - Private

    private func loadCollapsedGroups() {
        guard let data = UserDefaults.standard.data(forKey: Self.collapsedGroupsStorageKey),
              let decoded = try? JSONDecoder().decode(Set<String>.self, from: data)
        else { return }

        collapsedGroups = decoded
    }

    private func persistCollapsedGroups() {
        guard let data = try? JSONEncoder().encode(collapsedGroups) else { return }
        UserDefaults.standard.set(data, forKey: Self.collapsedGroupsStorageKey)
    }

    private func loadActiveIdsByAssistant() {
        guard let data = UserDefaults.standard.data(forKey: Self.activeIdsByAssistantKey),
              let decoded = try? JSONDecoder().decode([String: [String]].self, from: data)
        else { return }

        activeIdsByAssistant = decoded
    }

    private func persistActiveIdsByAssistant() {
        guard let data = try? JSONEncoder().encode(activeIdsByAssistant) else { return }
        UserDefaults.standard.set(data, forKey: Self.activeIdsByAssistantKey)
    }

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
