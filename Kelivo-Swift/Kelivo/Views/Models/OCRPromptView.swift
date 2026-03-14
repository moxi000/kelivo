import SwiftUI

// MARK: - OCR Prompt Configuration

/// Allows the user to view and edit the OCR system prompt used for image-to-text extraction.
/// Corresponds to Flutter: `lib/features/model/widgets/ocr_prompt_sheet.dart`
struct OCRPromptView: View {
    @Environment(\.dismiss) private var dismiss

    /// The current OCR prompt text, loaded on appear.
    @State private var promptText: String = ""

    /// Default prompt to reset to.
    private let defaultPrompt = "Please extract all text from this image accurately."

    /// Callback invoked with the updated prompt when the user saves.
    var onSave: ((String) -> Void)?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextEditor(text: $promptText)
                        .font(.body)
                        .frame(minHeight: 180)
                        .scrollContentBackground(.hidden)
                        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
                } header: {
                    Text(String(localized: "OCR Prompt"))
                } footer: {
                    Text(String(localized: "This prompt is sent along with images to guide the model's text extraction behavior."))
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
            .navigationTitle(String(localized: "OCR Prompt"))
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
            .onAppear(perform: loadPrompt)
        }
    }

    // MARK: - Actions

    private func loadPrompt() {
        // In production, load from UserDefaults or a settings model.
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
    OCRPromptView(onSave: { prompt in
        print("OCR prompt updated: \(prompt)")
    })
}
