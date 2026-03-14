import SwiftUI

// MARK: - Learning Prompt Editor

/// Allows the user to view and edit the system prompt used for learning / instruction injection mode.
/// Corresponds to Flutter: `lib/features/home/widgets/learning_prompt_sheet.dart`
struct LearningPromptView: View {
    @Environment(\.dismiss) private var dismiss

    /// The current prompt text, loaded on appear.
    @State private var promptText: String = ""

    /// Default prompt to reset to.
    private let defaultPrompt = "You are a helpful learning assistant. Focus on clear explanations and provide examples when possible."

    /// Callback invoked with the updated prompt when the user saves.
    var onSave: ((String) -> Void)?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextEditor(text: $promptText)
                        .font(.body)
                        .frame(minHeight: 200)
                        .scrollContentBackground(.hidden)
                        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
                } header: {
                    Text(String(localized: "System Prompt"))
                } footer: {
                    Text(String(localized: "This prompt is injected as a system message when learning mode is active."))
                }

                Section {
                    Button(role: .destructive) {
                        resetToDefault()
                    } label: {
                        Label(String(localized: "Reset to Default"), systemImage: "arrow.counterclockwise")
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle(String(localized: "Learning Prompt"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save")) { handleSave() }
                        .disabled(promptText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear(perform: loadPrompt)
        }
    }

    // MARK: - Actions

    private func loadPrompt() {
        // In production, load from the InstructionInjection model or UserDefaults.
        if promptText.isEmpty {
            promptText = defaultPrompt
        }
    }

    private func resetToDefault() {
        promptText = defaultPrompt
    }

    private func handleSave() {
        let trimmed = promptText.trimmingCharacters(in: .whitespacesAndNewlines)
        onSave?(trimmed)
        dismiss()
    }
}

#Preview {
    LearningPromptView(onSave: { prompt in
        print("Learning prompt updated: \(prompt)")
    })
}
