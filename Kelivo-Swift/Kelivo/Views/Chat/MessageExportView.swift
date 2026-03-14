import SwiftUI

// MARK: - ExportFormat

/// Supported export formats for chat messages.
enum ExportFormat: String, CaseIterable, Identifiable {
    case markdown
    case json
    case text

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .markdown: String(localized: "markdown")
        case .json: String(localized: "json")
        case .text: String(localized: "plainText")
        }
    }

    var fileExtension: String {
        switch self {
        case .markdown: "md"
        case .json: "json"
        case .text: "txt"
        }
    }

    var iconName: String {
        switch self {
        case .markdown: "doc.richtext"
        case .json: "curlybraces"
        case .text: "doc.plaintext"
        }
    }
}

// MARK: - MessageExportView

/// Allows selecting messages and export format, then sharing the result.
struct MessageExportView: View {
    let messages: [ChatMessage]

    @Environment(\.dismiss) private var dismiss

    @State private var selectedFormat: ExportFormat = .markdown
    @State private var selectedMessageIds: Set<String>
    @State private var isSharePresented = false
    @State private var exportedText = ""

    init(messages: [ChatMessage]) {
        self.messages = messages
        _selectedMessageIds = State(
            initialValue: Set(messages.map(\.id))
        )
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            List {
                formatSection
                messageSelectionSection
            }
            .navigationTitle(String(localized: "exportMessages"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar { toolbarContent }
            #if os(iOS)
            .sheet(isPresented: $isSharePresented) {
                ShareSheet(text: exportedText)
            }
            #endif
        }
    }

    // MARK: - Format Section

    private var formatSection: some View {
        Section {
            Picker(String(localized: "format"), selection: $selectedFormat) {
                ForEach(ExportFormat.allCases) { format in
                    Label(format.displayName, systemImage: format.iconName)
                        .tag(format)
                }
            }
            .pickerStyle(.segmented)
        } header: {
            Text(String(localized: "exportFormat"))
        }
    }

    // MARK: - Message Selection

    private var messageSelectionSection: some View {
        Section {
            // Select/deselect all
            Button {
                toggleSelectAll()
            } label: {
                Label(
                    allSelected
                        ? String(localized: "deselectAll")
                        : String(localized: "selectAll"),
                    systemImage: allSelected
                        ? "checkmark.circle.fill" : "circle"
                )
            }

            ForEach(messages) { message in
                Button {
                    toggleMessage(message)
                } label: {
                    HStack(spacing: 12) {
                        Image(
                            systemName: selectedMessageIds.contains(message.id)
                                ? "checkmark.circle.fill" : "circle"
                        )
                        .foregroundStyle(
                            selectedMessageIds.contains(message.id)
                                ? Color.accentPrimary : .secondary
                        )
                        .font(.title3)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(message.role.capitalized)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    message.role == "user"
                                        ? Color.accentPrimary : .secondary
                                )

                            Text(message.content)
                                .font(.subheadline)
                                .lineLimit(2)
                                .foregroundStyle(.primary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        } header: {
            Text(
                String(
                    localized:
                        "\(selectedMessageIds.count) of \(messages.count) selected"
                )
            )
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button(String(localized: "cancel")) {
                dismiss()
            }
        }

        ToolbarItem(placement: .confirmationAction) {
            Button(String(localized: "export")) {
                exportedText = generateExport()
                #if os(iOS)
                isSharePresented = true
                #elseif os(macOS)
                copyToClipboard(exportedText)
                dismiss()
                #endif
            }
            .disabled(selectedMessageIds.isEmpty)
        }
    }

    // MARK: - Helpers

    private var allSelected: Bool {
        selectedMessageIds.count == messages.count
    }

    private func toggleSelectAll() {
        if allSelected {
            selectedMessageIds.removeAll()
        } else {
            selectedMessageIds = Set(messages.map(\.id))
        }
    }

    private func toggleMessage(_ message: ChatMessage) {
        if selectedMessageIds.contains(message.id) {
            selectedMessageIds.remove(message.id)
        } else {
            selectedMessageIds.insert(message.id)
        }
    }

    private var selectedMessages: [ChatMessage] {
        messages.filter { selectedMessageIds.contains($0.id) }
    }

    // MARK: - Export Generation

    private func generateExport() -> String {
        switch selectedFormat {
        case .markdown:
            return generateMarkdown()
        case .json:
            return generateJSON()
        case .text:
            return generatePlainText()
        }
    }

    private func generateMarkdown() -> String {
        selectedMessages.map { message in
            let role =
                message.role == "user"
                ? "**User**" : "**Assistant**"
            return "\(role)\n\n\(message.content)"
        }
        .joined(separator: "\n\n---\n\n")
    }

    private func generateJSON() -> String {
        let entries = selectedMessages.map { message -> [String: String] in
            [
                "role": message.role,
                "content": message.content,
                "timestamp": ISO8601DateFormatter().string(
                    from: message.timestamp),
            ]
        }
        guard let data = try? JSONSerialization.data(
            withJSONObject: entries,
            options: [.prettyPrinted, .sortedKeys]
        ) else { return "[]" }
        return String(data: data, encoding: .utf8) ?? "[]"
    }

    private func generatePlainText() -> String {
        selectedMessages.map { message in
            let role = message.role == "user" ? "User" : "Assistant"
            return "[\(role)]\n\(message.content)"
        }
        .joined(separator: "\n\n")
    }

    #if os(macOS)
    private func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
    #endif
}

// MARK: - Share Sheet (iOS)

#if os(iOS)
import UIKit

private struct ShareSheet: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}
#endif

// MARK: - Preview

#Preview {
    MessageExportView(messages: [
        ChatMessage(
            role: "user",
            content: "Hello!",
            conversationId: "preview"
        ),
        ChatMessage(
            role: "assistant",
            content: "Hi there! How can I help?",
            conversationId: "preview"
        ),
    ])
}
