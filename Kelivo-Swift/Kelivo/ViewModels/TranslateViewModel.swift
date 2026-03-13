import Foundation
import Observation

@Observable
final class TranslateViewModel {

    // MARK: Published State

    var sourceText: String = ""
    var translatedText: String = ""
    var sourceLang: String = "auto"
    var targetLang: String = "en"
    var isTranslating: Bool = false

    // MARK: - Translation

    func translate() async throws {
        let text = sourceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        isTranslating = true
        translatedText = ""
        defer { isTranslating = false }

        // TODO: Implement translation using the configured LLM provider
        // 1. Build a translation prompt with sourceLang, targetLang, and text
        // 2. Call the LLM API (reuse the provider/model configuration from ProviderViewModel)
        // 3. Parse the response and set translatedText
        //
        // Example prompt structure:
        // "Translate the following text from \(sourceLang) to \(targetLang):\n\n\(text)"
    }

    // MARK: - Actions

    func swapLanguages() {
        guard sourceLang != "auto" else { return }

        let previousSource = sourceLang
        let previousTarget = targetLang
        sourceLang = previousTarget
        targetLang = previousSource

        let previousSourceText = sourceText
        let previousTranslated = translatedText
        sourceText = previousTranslated
        translatedText = previousSourceText
    }

    func clear() {
        sourceText = ""
        translatedText = ""
    }
}
