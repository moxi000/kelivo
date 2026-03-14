import SwiftUI

// MARK: - MCP Server Display Entry

private struct MCPServerDisplayEntry: Identifiable {
    let id: String
    var name: String
    var isEnabled: Bool
    var tools: [MCPToolDisplayEntry]
}

private struct MCPToolDisplayEntry: Identifiable {
    let id = UUID().uuidString
    var name: String
    var isEnabled: Bool
}

struct AssistantMCPTab: View {
    @Binding var enabledServerIds: [String]

    @State private var servers: [MCPServerDisplayEntry] = []

    var body: some View {
        Form {
            Section {
                Text(String(localized: "Select MCP servers to enable for this assistant."))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // MARK: - Server List
            ForEach($servers) { $server in
                Section {
                    Toggle(server.name, isOn: $server.isEnabled)
                        .onChange(of: server.isEnabled) { _, enabled in
                            updateEnabledIds(serverId: server.id, enabled: enabled)
                        }

                    if server.isEnabled && !server.tools.isEmpty {
                        DisclosureGroup(String(localized: "Tools (\(server.tools.count))")) {
                            ForEach($server.tools) { $tool in
                                Toggle(tool.name, isOn: $tool.isEnabled)
                                    .font(.caption)
                            }
                        }
                    }
                } header: {
                    Label(server.name, systemImage: "server.rack")
                }
            }
        }
        .formStyle(.grouped)
        .overlay {
            if servers.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No MCP Servers"), systemImage: "point.3.connected.trianglepath.dotted")
                } description: {
                    Text(String(localized: "Add MCP servers in settings first."))
                }
            }
        }
    }

    // MARK: - Actions

    private func updateEnabledIds(serverId: String, enabled: Bool) {
        if enabled {
            if !enabledServerIds.contains(serverId) {
                enabledServerIds.append(serverId)
            }
        } else {
            enabledServerIds.removeAll { $0 == serverId }
        }
    }
}

#Preview {
    AssistantMCPTab(enabledServerIds: .constant([]))
}
