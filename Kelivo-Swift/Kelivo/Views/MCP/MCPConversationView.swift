import SwiftUI
import SwiftData

// MARK: - MCP Conversation Configuration

/// Allows the user to toggle which connected MCP servers are active for a specific conversation.
/// Corresponds to Flutter: `lib/features/mcp/widgets/mcp_conversation_sheet.dart`
struct MCPConversationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let conversationId: String

    /// All available MCP server entries (would come from a query or binding in production).
    @State private var servers: [MCPServerListItem] = []
    @State private var selectedServerIds: Set<String> = []

    var body: some View {
        NavigationStack {
            List {
                if servers.isEmpty {
                    ContentUnavailableView {
                        Label(String(localized: "No Running Servers"), systemImage: "point.3.connected.trianglepath.dotted")
                    } description: {
                        Text(String(localized: "No MCP servers are currently connected. Start a server first."))
                    }
                } else {
                    Section {
                        ForEach(servers) { server in
                            serverRow(server)
                        }
                    } header: {
                        Text(String(localized: "Connected Servers"))
                    } footer: {
                        Text(String(localized: "Toggle servers to enable or disable them for this conversation."))
                    }
                }
            }
            .navigationTitle(String(localized: "Conversation MCP"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Close")) { dismiss() }
                }

                if !servers.isEmpty {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button(String(localized: "Select All")) {
                            selectAll()
                        }

                        Button(String(localized: "Clear All")) {
                            clearAll()
                        }
                    }
                }
            }
            .onAppear(perform: loadState)
        }
    }

    // MARK: - Server Row

    private func serverRow(_ server: MCPServerListItem) -> some View {
        let isSelected = selectedServerIds.contains(server.id)

        return HStack(spacing: 12) {
            Image(systemName: "terminal")
                .font(.body)
                .foregroundStyle(.tint)
                .frame(width: 32, height: 32)
                .background(Color.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(server.name)
                    .font(.body.weight(.semibold))
                    .lineLimit(1)

                HStack(spacing: 6) {
                    tagLabel(String(localized: "Connected"))
                    tagLabel(String(localized: "\(server.enabledToolCount)/\(server.totalToolCount) tools"))
                    tagLabel(server.transportLabel)
                }
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { isSelected },
                set: { enabled in
                    toggleServer(server.id, enabled: enabled)
                }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 2)
    }

    // MARK: - Tag Label

    private func tagLabel(_ text: String) -> some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.tint)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.accentColor.opacity(0.10), in: Capsule())
            .overlay(Capsule().strokeBorder(Color.accentColor.opacity(0.35), lineWidth: 0.5))
    }

    // MARK: - Actions

    private func loadState() {
        // In production, load the conversation's mcpServerIds from SwiftData
        // and populate `servers` from the MCP service's connected server list.
    }

    private func toggleServer(_ serverId: String, enabled: Bool) {
        if enabled {
            selectedServerIds.insert(serverId)
        } else {
            selectedServerIds.remove(serverId)
        }
        persistSelection()
    }

    private func selectAll() {
        selectedServerIds = Set(servers.map(\.id))
        persistSelection()
    }

    private func clearAll() {
        selectedServerIds.removeAll()
        persistSelection()
    }

    private func persistSelection() {
        // In production, update the Conversation model's mcpServerIds
        // via modelContext or a dedicated service.
    }
}

// MARK: - Supporting Types

/// Lightweight view-model for an MCP server entry shown in the conversation picker.
private struct MCPServerListItem: Identifiable {
    let id: String
    let name: String
    let transport: String // "stdio", "sse", "http"
    let enabledToolCount: Int
    let totalToolCount: Int

    var transportLabel: String {
        switch transport {
        case "inmemory": return String(localized: "In-Memory")
        case "sse": return "SSE"
        default: return "HTTP"
        }
    }
}

#Preview {
    MCPConversationView(conversationId: "preview-conv-id")
}
