import SwiftUI

// MARK: - MCP Timeout Configuration

/// Allows the user to configure the MCP request timeout in seconds.
/// Corresponds to Flutter: `lib/features/mcp/widgets/mcp_timeout_sheet.dart`
struct MCPTimeoutView: View {
    @Environment(\.dismiss) private var dismiss

    /// Current timeout value in seconds, passed from the parent.
    @State private var timeoutSeconds: String = "30"

    /// Callback invoked with the validated timeout when the user saves.
    var onSave: ((Int) -> Void)?

    @State private var showInvalidAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(
                        String(localized: "Timeout (seconds)"),
                        text: $timeoutSeconds
                    )
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                    .autocorrectionDisabled()
                } header: {
                    Text(String(localized: "Request Timeout"))
                } footer: {
                    Text(String(localized: "Maximum time in seconds to wait for an MCP server response. Must be a positive integer."))
                }
            }
            .formStyle(.grouped)
            .navigationTitle(String(localized: "MCP Timeout"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save")) { handleSave() }
                }
            }
            .alert(
                String(localized: "Invalid Value"),
                isPresented: $showInvalidAlert
            ) {
                Button(String(localized: "OK"), role: .cancel) {}
            } message: {
                Text(String(localized: "Please enter a positive integer for the timeout."))
            }
        }
    }

    // MARK: - Actions

    private func handleSave() {
        let raw = timeoutSeconds.trimmingCharacters(in: .whitespaces)
        guard let seconds = Int(raw), seconds > 0 else {
            showInvalidAlert = true
            return
        }
        onSave?(seconds)
        dismiss()
    }
}

#Preview {
    MCPTimeoutView(onSave: { seconds in
        print("Timeout set to \(seconds)s")
    })
}
