import SwiftUI

// MARK: - MCP Server Model (local to view)

private enum MCPTransportType: String, CaseIterable {
    case stdio
    case sse
}

struct MCPServersView: View {
    @State private var servers: [MCPServerEntry] = []
    @State private var showAddServer = false

    // Add server form
    @State private var newName = ""
    @State private var newCommand = ""
    @State private var newArgs = ""
    @State private var newEnvVars = ""
    @State private var newTransport: String = "stdio"

    var body: some View {
        List {
            // MARK: - Server List
            ForEach(servers) { server in
                serverRow(server)
            }
            .onDelete { offsets in
                servers.remove(atOffsets: offsets)
            }

            // MARK: - Add Server
            Section {
                Button {
                    showAddServer.toggle()
                } label: {
                    Label(String(localized: "Add MCP Server"), systemImage: "plus.circle")
                }
            }

            if showAddServer {
                Section {
                    TextField(String(localized: "Server Name"), text: $newName)

                    Picker(String(localized: "Transport"), selection: $newTransport) {
                        Text("stdio").tag("stdio")
                        Text("SSE").tag("sse")
                    }
                    #if os(iOS)
                    .pickerStyle(.segmented)
                    #endif

                    TextField(String(localized: "Command"), text: $newCommand)
                        .autocorrectionDisabled()
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif

                    TextField(String(localized: "Arguments (space-separated)"), text: $newArgs)
                        .autocorrectionDisabled()
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif

                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "Environment Variables"))
                            .font(.subheadline)
                        TextEditor(text: $newEnvVars)
                            .font(.caption.monospaced())
                            .frame(minHeight: 60)
                            .scrollContentBackground(.hidden)
                            .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
                    }

                    Button {
                        addServer()
                    } label: {
                        Text(String(localized: "Add Server"))
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(newName.isEmpty || newCommand.isEmpty)
                    .applyGlassProminent()
                } header: {
                    Text(String(localized: "New Server"))
                }
            }
        }
        .navigationTitle(String(localized: "MCP Servers"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .overlay {
            if servers.isEmpty && !showAddServer {
                ContentUnavailableView {
                    Label(String(localized: "No MCP Servers"), systemImage: "point.3.connected.trianglepath.dotted")
                } description: {
                    Text(String(localized: "Add an MCP server to extend your assistant's capabilities with tools."))
                }
            }
        }
    }

    // MARK: - Row

    private func serverRow(_ server: MCPServerEntry) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(server.isConnected ? .green : .red)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(server.name)
                    .font(.body)
                Text(server.command)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                if !server.tools.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "wrench")
                            .font(.caption2)
                        Text(String(localized: "\(server.tools.count) tools"))
                            .font(.caption2)
                    }
                    .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { server.isEnabled },
                set: { enabled in
                    if let idx = servers.firstIndex(where: { $0.id == server.id }) {
                        servers[idx].isEnabled = enabled
                    }
                }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 2)
    }

    // MARK: - Actions

    private func addServer() {
        let server = MCPServerEntry(
            name: newName,
            command: newCommand,
            args: newArgs.split(separator: " ").map(String.init),
            transport: newTransport,
            envVars: newEnvVars
        )
        servers.append(server)
        newName = ""
        newCommand = ""
        newArgs = ""
        newEnvVars = ""
        showAddServer = false
    }
}

// MARK: - Supporting Types

private struct MCPServerEntry: Identifiable {
    let id = UUID().uuidString
    var name: String
    var command: String
    var args: [String]
    var transport: String
    var envVars: String
    var isEnabled: Bool = true
    var isConnected: Bool = false
    var tools: [String] = []
}

// MARK: - Glass Style

private extension View {
    @ViewBuilder
    func applyGlassProminent() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigationStack {
        MCPServersView()
    }
}
