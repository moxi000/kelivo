import SwiftUI

// MARK: - Environment Variable Entry

private struct EnvVarEntry: Identifiable {
    let id = UUID().uuidString
    var key: String
    var value: String
}

// MARK: - Header Entry

private struct HeaderEntry: Identifiable {
    let id = UUID().uuidString
    var key: String
    var value: String
}

struct MCPServerEditView: View {
    @Environment(\.dismiss) private var dismiss

    /// Pass nil to create a new server.
    let server: MCPServerEntry?

    @State private var name = ""
    @State private var urlOrCommand = ""
    @State private var transport = "stdio"
    @State private var envVars: [EnvVarEntry] = []
    @State private var headers: [HeaderEntry] = []
    @State private var autoConnect = true
    @State private var isTesting = false
    @State private var testResult: String?

    private var isNew: Bool { server == nil }

    var body: some View {
        Form {
            // MARK: - General
            Section {
                TextField(String(localized: "Server Name"), text: $name)

                Picker(String(localized: "Transport"), selection: $transport) {
                    Text("stdio").tag("stdio")
                    Text("SSE").tag("sse")
                }
                #if os(iOS)
                .pickerStyle(.segmented)
                #endif

                TextField(
                    transport == "stdio"
                        ? String(localized: "Command")
                        : String(localized: "Server URL"),
                    text: $urlOrCommand
                )
                .autocorrectionDisabled()
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif

                Toggle(String(localized: "Auto-connect"), isOn: $autoConnect)
            } header: {
                Text(String(localized: "General"))
            }

            // MARK: - Environment Variables
            Section {
                ForEach($envVars) { $entry in
                    HStack(spacing: 8) {
                        TextField(String(localized: "Key"), text: $entry.key)
                            .autocorrectionDisabled()
                            #if os(iOS)
                            .textInputAutocapitalization(.never)
                            #endif
                        TextField(String(localized: "Value"), text: $entry.value)
                            .autocorrectionDisabled()
                            #if os(iOS)
                            .textInputAutocapitalization(.never)
                            #endif
                    }
                }
                .onDelete { offsets in
                    envVars.remove(atOffsets: offsets)
                }

                Button {
                    envVars.append(EnvVarEntry(key: "", value: ""))
                } label: {
                    Label(String(localized: "Add Variable"), systemImage: "plus.circle")
                }
            } header: {
                Text(String(localized: "Environment Variables"))
            }

            // MARK: - Headers
            Section {
                ForEach($headers) { $entry in
                    HStack(spacing: 8) {
                        TextField(String(localized: "Header"), text: $entry.key)
                            .autocorrectionDisabled()
                            #if os(iOS)
                            .textInputAutocapitalization(.never)
                            #endif
                        TextField(String(localized: "Value"), text: $entry.value)
                            .autocorrectionDisabled()
                            #if os(iOS)
                            .textInputAutocapitalization(.never)
                            #endif
                    }
                }
                .onDelete { offsets in
                    headers.remove(atOffsets: offsets)
                }

                Button {
                    headers.append(HeaderEntry(key: "", value: ""))
                } label: {
                    Label(String(localized: "Add Header"), systemImage: "plus.circle")
                }
            } header: {
                Text(String(localized: "Headers"))
            }

            // MARK: - Test Connection
            Section {
                Button {
                    testConnection()
                } label: {
                    HStack {
                        if isTesting {
                            ProgressView()
                                .controlSize(.small)
                        }
                        Text(String(localized: "Test Connection"))
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(name.isEmpty || urlOrCommand.isEmpty || isTesting)
                .applyGlassProminent()

                if let testResult {
                    Text(testResult)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(isNew ? String(localized: "Add MCP Server") : name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Cancel")) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Save")) { save() }
                    .disabled(name.isEmpty || urlOrCommand.isEmpty)
            }
        }
        .onAppear(perform: loadServer)
    }

    // MARK: - Actions

    private func loadServer() {
        guard let server else { return }
        name = server.name
        urlOrCommand = server.command
        transport = server.transport
    }

    private func save() {
        // Persist through parent callback or model context
        dismiss()
    }

    private func testConnection() {
        isTesting = true
        testResult = nil
        // Simulate test — real implementation would attempt connection
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTesting = false
            testResult = String(localized: "Connection test completed.")
        }
    }
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
        MCPServerEditView(server: nil)
    }
}
