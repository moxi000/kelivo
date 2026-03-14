import SwiftUI

// MARK: - Tool Entry (local to view)

private struct MCPToolEntry: Identifiable {
    let id = UUID().uuidString
    var name: String
    var description: String
    var inputSchema: String
    var serverName: String
    var isEnabled: Bool = true
}

struct MCPToolsView: View {
    @State private var tools: [MCPToolEntry] = []
    @State private var isRefreshing = false

    /// Group tools by server name.
    private var groupedTools: [(server: String, tools: [MCPToolEntry])] {
        let dict = Dictionary(grouping: tools, by: \.serverName)
        return dict
            .sorted { $0.key < $1.key }
            .map { (server: $0.key, tools: $0.value) }
    }

    var body: some View {
        List {
            ForEach(groupedTools, id: \.server) { group in
                Section {
                    ForEach(group.tools) { tool in
                        toolRow(tool)
                    }
                } header: {
                    Label(group.server, systemImage: "server.rack")
                }
            }
        }
        .navigationTitle(String(localized: "MCP Tools"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    refreshTools()
                } label: {
                    if isRefreshing {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .disabled(isRefreshing)
            }
        }
        .overlay {
            if tools.isEmpty && !isRefreshing {
                ContentUnavailableView {
                    Label(String(localized: "No Tools"), systemImage: "wrench")
                } description: {
                    Text(String(localized: "Connect an MCP server to see available tools."))
                }
            }
        }
    }

    // MARK: - Tool Row

    private func toolRow(_ tool: MCPToolEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)
                    .font(.body.monospaced())

                if !tool.description.isEmpty {
                    Text(tool.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }

                if !tool.inputSchema.isEmpty {
                    Text(tool.inputSchema)
                        .font(.caption2.monospaced())
                        .foregroundStyle(.tertiary)
                        .lineLimit(2)
                }
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { tool.isEnabled },
                set: { enabled in
                    if let idx = tools.firstIndex(where: { $0.id == tool.id }) {
                        tools[idx].isEnabled = enabled
                    }
                }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 2)
    }

    // MARK: - Actions

    private func refreshTools() {
        isRefreshing = true
        // Real implementation would query connected MCP servers
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isRefreshing = false
        }
    }
}

#Preview {
    NavigationStack {
        MCPToolsView()
    }
}
