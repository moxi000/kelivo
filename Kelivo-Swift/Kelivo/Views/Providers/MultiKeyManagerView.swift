import SwiftUI

struct MultiKeyManagerView: View {
    @State var keys: [ApiKeyConfig]
    @State var config: KeyManagementConfig

    @State private var showAddKey = false
    @State private var newKeyValue = ""
    @State private var newKeyName = ""

    var body: some View {
        Form {
            // MARK: - API Keys
            Section {
                if keys.isEmpty {
                    Text(String(localized: "No API keys configured."))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(keys) { key in
                        keyRow(key)
                    }
                    .onDelete(perform: deleteKeys)
                }
            } header: {
                HStack {
                    Text(String(localized: "API Keys"))
                    Spacer()
                    Button {
                        showAddKey = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .buttonStyle(.plain)
                }
            }

            // MARK: - Load Balancing
            Section {
                Picker(String(localized: "Strategy"), selection: $config.strategy) {
                    Text(String(localized: "Round Robin")).tag(LoadBalanceStrategy.roundRobin)
                    Text(String(localized: "Priority")).tag(LoadBalanceStrategy.priority)
                    Text(String(localized: "Least Used")).tag(LoadBalanceStrategy.leastUsed)
                    Text(String(localized: "Random")).tag(LoadBalanceStrategy.random)
                }

                Stepper(
                    String(localized: "Max Failures: \(config.maxFailuresBeforeDisable)"),
                    value: $config.maxFailuresBeforeDisable,
                    in: 1...20
                )

                Stepper(
                    String(localized: "Recovery Time: \(config.failureRecoveryTimeMinutes) min"),
                    value: $config.failureRecoveryTimeMinutes,
                    in: 1...60
                )

                Toggle(String(localized: "Auto Recovery"), isOn: $config.enableAutoRecovery)
            } header: {
                Text(String(localized: "Load Balancing"))
            } footer: {
                Text(String(localized: "Controls how requests are distributed across multiple API keys."))
            }

            // MARK: - Usage Stats
            if !keys.isEmpty {
                Section {
                    ForEach(keys) { key in
                        usageRow(key)
                    }
                } header: {
                    Text(String(localized: "Usage Statistics"))
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "API Key Manager"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(isPresented: $showAddKey) {
            addKeySheet
        }
    }

    // MARK: - Key Row

    private func keyRow(_ key: ApiKeyConfig) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(colorForStatus(key.status))
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(key.name ?? maskedKey(key.key))
                    .font(.body)
                HStack(spacing: 6) {
                    Text(key.status.rawValue.capitalized)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(String(localized: "Priority: \(key.priority)"))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if key.isEnabled {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.caption)
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .padding(.vertical, 2)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                keys.removeAll { $0.id == key.id }
            } label: {
                Label(String(localized: "Delete"), systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                toggleKey(key)
            } label: {
                Label(
                    key.isEnabled ? String(localized: "Disable") : String(localized: "Enable"),
                    systemImage: key.isEnabled ? "xmark.circle" : "checkmark.circle"
                )
            }
            .tint(key.isEnabled ? .orange : .green)
        }
    }

    // MARK: - Usage Row

    private func usageRow(_ key: ApiKeyConfig) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(key.name ?? maskedKey(key.key))
                .font(.subheadline)

            HStack(spacing: 16) {
                statLabel(
                    title: String(localized: "Requests"),
                    value: "\(key.usage.totalRequests)"
                )
                statLabel(
                    title: String(localized: "Success Rate"),
                    value: successRate(key.usage)
                )
                statLabel(
                    title: String(localized: "Last Used"),
                    value: lastUsedText(key.usage.lastUsed)
                )
            }
        }
        .padding(.vertical, 2)
    }

    private func statLabel(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.monospacedDigit())
        }
    }

    // MARK: - Add Key Sheet

    private var addKeySheet: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(String(localized: "Key Name (Optional)"), text: $newKeyName)
                    SecureField(String(localized: "API Key"), text: $newKeyValue)
                        .autocorrectionDisabled()
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                } header: {
                    Text(String(localized: "New API Key"))
                }
            }
            .formStyle(.grouped)
            .navigationTitle(String(localized: "Add API Key"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) {
                        showAddKey = false
                        resetAddForm()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Add")) {
                        addKey()
                    }
                    .disabled(newKeyValue.isEmpty)
                }
            }
        }
    }

    // MARK: - Actions

    private func addKey() {
        let key = ApiKeyConfig.create(
            key: newKeyValue,
            name: newKeyName.isEmpty ? nil : newKeyName
        )
        keys.append(key)
        showAddKey = false
        resetAddForm()
    }

    private func deleteKeys(at offsets: IndexSet) {
        keys.remove(atOffsets: offsets)
    }

    private func toggleKey(_ key: ApiKeyConfig) {
        guard let index = keys.firstIndex(where: { $0.id == key.id }) else { return }
        keys[index].isEnabled.toggle()
    }

    private func resetAddForm() {
        newKeyValue = ""
        newKeyName = ""
    }

    // MARK: - Helpers

    private func maskedKey(_ key: String) -> String {
        guard key.count > 8 else { return "••••••••" }
        let prefix = key.prefix(4)
        let suffix = key.suffix(4)
        return "\(prefix)••••\(suffix)"
    }

    private func colorForStatus(_ status: ApiKeyStatus) -> Color {
        switch status {
        case .active: return .green
        case .disabled: return .gray
        case .error: return .red
        case .rateLimited: return .orange
        }
    }

    private func successRate(_ usage: ApiKeyUsage) -> String {
        guard usage.totalRequests > 0 else { return "—" }
        let rate = Double(usage.successfulRequests) / Double(usage.totalRequests) * 100
        return String(format: "%.1f%%", rate)
    }

    private func lastUsedText(_ timestamp: Int?) -> String {
        guard let ts = timestamp else { return String(localized: "Never") }
        let date = Date(timeIntervalSince1970: Double(ts) / 1000)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: .now)
    }
}

#Preview {
    NavigationStack {
        MultiKeyManagerView(
            keys: [
                ApiKeyConfig.create(key: "sk-test-1234567890abcdef", name: "Primary Key"),
                ApiKeyConfig.create(key: "sk-test-abcdef1234567890", name: "Backup Key"),
            ],
            config: KeyManagementConfig()
        )
    }
}
