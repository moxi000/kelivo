import SwiftUI

@available(iOS 26.0, macOS 26.0, *)
struct TranslateView: View {
    @Environment(TranslateViewModel.self) private var translateVM

    private let languages = [
        ("auto", "Auto Detect"),
        ("en", "English"),
        ("zh-Hans", "简体中文"),
        ("zh-Hant", "繁體中文"),
        ("ja", "日本語"),
        ("ko", "한국어"),
        ("fr", "Français"),
        ("de", "Deutsch"),
        ("es", "Español"),
        ("pt", "Português"),
        ("ru", "Русский"),
        ("ar", "العربية"),
    ]

    var body: some View {
        @Bindable var vm = translateVM
        VStack(spacing: 16) {
            // Language selectors
            HStack {
                Picker(String(localized: "sourceLang"), selection: $vm.sourceLang) {
                    ForEach(languages, id: \.0) { code, name in
                        Text(name).tag(code)
                    }
                }
                .frame(maxWidth: .infinity)

                Button {
                    translateVM.swapLanguages()
                } label: {
                    Image(systemName: "arrow.left.arrow.right")
                }
                .buttonStyle(.glass)

                Picker(String(localized: "targetLang"), selection: $vm.targetLang) {
                    ForEach(languages.filter { $0.0 != "auto" }, id: \.0) { code, name in
                        Text(name).tag(code)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)

            // Source text
            VStack(alignment: .leading, spacing: 4) {
                Text(String(localized: "sourceText"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextEditor(text: $vm.sourceText)
                    .frame(minHeight: 120)
                    .padding(8)
                    .glassEffect(.regular, in: .rect(cornerRadius: 12))
            }
            .padding(.horizontal)

            // Translate button
            Button {
                Task { try? await translateVM.translate() }
            } label: {
                if translateVM.isTranslating {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Label(String(localized: "translate"), systemImage: "translate")
                }
            }
            .buttonStyle(.glassProminent)
            .disabled(translateVM.sourceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || translateVM.isTranslating)

            // Result text
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(String(localized: "translatedText"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if !translateVM.translatedText.isEmpty {
                        Button {
                            #if os(macOS)
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(translateVM.translatedText, forType: .string)
                            #else
                            UIPasteboard.general.string = translateVM.translatedText
                            #endif
                        } label: {
                            Image(systemName: "doc.on.doc")
                        }
                        .buttonStyle(.glass)
                    }
                }
                TextEditor(text: .constant(translateVM.translatedText))
                    .frame(minHeight: 120)
                    .padding(8)
                    .glassEffect(.regular, in: .rect(cornerRadius: 12))
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .navigationTitle(String(localized: "translate"))
    }
}
