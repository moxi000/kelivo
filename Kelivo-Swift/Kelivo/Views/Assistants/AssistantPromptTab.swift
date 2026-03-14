import SwiftUI

struct AssistantPromptTab: View {
    @Binding var systemPrompt: String

    @State private var showTemplates = false

    /// Available template variables for reference.
    private let variables: [(name: String, description: String)] = [
        ("{{user}}", String(localized: "Current user name")),
        ("{{date}}", String(localized: "Current date")),
        ("{{time}}", String(localized: "Current time")),
        ("{{assistant}}", String(localized: "Assistant name")),
        ("{{message}}", String(localized: "User message")),
    ]

    /// Preset prompt templates.
    private let templates: [(name: String, prompt: String)] = [
        (String(localized: "General Assistant"), "You are a helpful assistant."),
        (String(localized: "Translator"), "You are a professional translator. Translate the user's input accurately while preserving tone and meaning."),
        (String(localized: "Code Helper"), "You are an expert software engineer. Help the user with code questions, debugging, and best practices."),
        (String(localized: "Writing Coach"), "You are a skilled writing coach. Help the user improve their writing with clear, constructive feedback."),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Editor
            TextEditor(text: $systemPrompt)
                .font(.body)
                .scrollContentBackground(.hidden)
                .padding()
                .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 12))
                .padding()

            // MARK: - Stats
            HStack {
                Text(String(localized: "\(systemPrompt.count) characters"))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    showTemplates.toggle()
                } label: {
                    Label(String(localized: "Templates"), systemImage: "doc.text")
                        .font(.caption)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

            // MARK: - Variables Reference
            DisclosureGroup {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(variables, id: \.name) { variable in
                        HStack(spacing: 8) {
                            Text(variable.name)
                                .font(.caption.monospaced())
                                .foregroundStyle(.tint)
                            Text(variable.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.top, 4)
            } label: {
                Text(String(localized: "Variables Reference"))
                    .font(.caption)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .sheet(isPresented: $showTemplates) {
            NavigationStack {
                List(templates, id: \.name) { template in
                    Button {
                        systemPrompt = template.prompt
                        showTemplates = false
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(template.name)
                                .font(.body)
                            Text(template.prompt)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(3)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .navigationTitle(String(localized: "Prompt Templates"))
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(String(localized: "Cancel")) { showTemplates = false }
                    }
                }
            }
        }
    }
}

#Preview {
    AssistantPromptTab(systemPrompt: .constant("You are a helpful assistant."))
}
