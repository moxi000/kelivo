import SwiftUI

struct MCPJsonEditView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var jsonText: String
    @State private var validationError: String?

    let title: String
    let onSave: (String) -> Void

    init(
        title: String = String(localized: "Edit JSON"),
        json: String = "",
        onSave: @escaping (String) -> Void
    ) {
        self.title = title
        self._jsonText = State(initialValue: json)
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Editor
            TextEditor(text: $jsonText)
                .font(.body.monospaced())
                .scrollContentBackground(.hidden)
                .padding()
                .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 12))
                .padding()

            // MARK: - Validation Error
            if let validationError {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text(validationError)
                }
                .font(.caption)
                .foregroundStyle(.red)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }

            // MARK: - Action Bar
            HStack(spacing: 12) {
                Button {
                    prettifyJson()
                } label: {
                    Label(String(localized: "Format"), systemImage: "text.alignleft")
                }

                Button {
                    copyToClipboard()
                } label: {
                    Label(String(localized: "Copy"), systemImage: "doc.on.doc")
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle(title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Cancel")) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Save")) { saveJson() }
            }
        }
    }

    // MARK: - Actions

    private func prettifyJson() {
        guard let data = jsonText.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data),
              let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys]),
              let str = String(data: pretty, encoding: .utf8)
        else {
            validationError = String(localized: "Invalid JSON — cannot format.")
            return
        }
        validationError = nil
        jsonText = str
    }

    private func copyToClipboard() {
        #if os(iOS)
        UIPasteboard.general.string = jsonText
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(jsonText, forType: .string)
        #endif
    }

    private func saveJson() {
        // Validate JSON before saving
        if !jsonText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            guard let data = jsonText.data(using: .utf8),
                  (try? JSONSerialization.jsonObject(with: data)) != nil
            else {
                validationError = String(localized: "Invalid JSON — please fix before saving.")
                return
            }
        }
        validationError = nil
        onSave(jsonText)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        MCPJsonEditView(json: "{\n  \"key\": \"value\"\n}") { _ in }
    }
}
