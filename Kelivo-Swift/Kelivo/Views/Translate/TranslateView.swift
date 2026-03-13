import SwiftUI

struct TranslateView: View {
    @State private var sourceText = ""
    @State private var targetText = ""
    @State private var sourceLanguage = "auto"
    @State private var targetLanguage = "en"
    @State private var isTranslating = false

    private let languages: [(String, String)] = [
        ("auto", String(localized: "Auto Detect")),
        ("en", String(localized: "English")),
        ("zh-Hans", String(localized: "Chinese (Simplified)")),
        ("zh-Hant", String(localized: "Chinese (Traditional)")),
        ("ja", String(localized: "Japanese")),
        ("ko", String(localized: "Korean")),
        ("fr", String(localized: "French")),
        ("de", String(localized: "German")),
        ("es", String(localized: "Spanish")),
        ("pt", String(localized: "Portuguese")),
        ("ru", String(localized: "Russian")),
        ("ar", String(localized: "Arabic")),
        ("it", String(localized: "Italian")),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Language Pickers
            HStack {
                Picker(String(localized: "Source"), selection: $sourceLanguage) {
                    ForEach(languages, id: \.0) { code, name in
                        Text(name).tag(code)
                    }
                }
                .labelsHidden()

                Button {
                    swapLanguages()
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.title3)
                        .padding(8)
                }
                .glassCard(cornerRadius: 8)
                .disabled(sourceLanguage == "auto")

                Picker(String(localized: "Target"), selection: $targetLanguage) {
                    ForEach(languages.filter({ $0.0 != "auto" }), id: \.0) { code, name in
                        Text(name).tag(code)
                    }
                }
                .labelsHidden()
            }
            .padding()

            Divider()

            // MARK: - Source Text
            VStack(alignment: .leading, spacing: 4) {
                Text(String(localized: "Source Text"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                TextEditor(text: $sourceText)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal)
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 8)

            Divider()

            // MARK: - Target Text
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(String(localized: "Translation"))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Spacer()

                    if !targetText.isEmpty {
                        Button {
                            copyResult()
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .font(.caption)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)

                if isTranslating {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        Text(targetText.isEmpty ? String(localized: "Translation will appear here") : targetText)
                            .font(.body)
                            .foregroundStyle(targetText.isEmpty ? .secondary : .primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .textSelection(.enabled)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .padding(.top, 8)

            Divider()

            // MARK: - Translate Button
            HStack {
                Spacer()

                Button {
                    translate()
                } label: {
                    HStack {
                        Image(systemName: "character.book.closed")
                        Text(String(localized: "Translate"))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                }
                .applyGlassProminentButton()
                .disabled(sourceText.isEmpty || isTranslating)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(String(localized: "Translate"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Actions

    private func translate() {
        isTranslating = true
        Task {
            // Placeholder — real implementation would call an LLM with a translation prompt
            try? await Task.sleep(for: .seconds(1.5))
            targetText = String(localized: "[Translation result would appear here]")
            isTranslating = false
        }
    }

    private func swapLanguages() {
        let temp = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = temp
        let tempText = sourceText
        sourceText = targetText
        targetText = tempText
    }

    private func copyResult() {
        #if os(iOS)
        UIPasteboard.general.string = targetText
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(targetText, forType: .string)
        #endif
    }
}

// MARK: - Glass Button Style

private extension View {
    @ViewBuilder
    func applyGlassProminentButton() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigationStack {
        TranslateView()
    }
}
