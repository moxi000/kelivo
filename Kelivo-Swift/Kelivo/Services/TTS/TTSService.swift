import AVFoundation

// MARK: - TTS State

enum TTSState: Sendable {
    case idle
    case playing
    case paused
}

// MARK: - TTS Error

enum TTSError: Error, LocalizedError {
    case notAvailable
    case voiceNotFound(String)
    case synthesizeFailed(String)

    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Text-to-speech is not available"
        case let .voiceNotFound(identifier):
            return "TTS voice not found: \(identifier)"
        case let .synthesizeFailed(detail):
            return "TTS synthesis failed: \(detail)"
        }
    }
}

// MARK: - TTS Service

/// System TTS service using AVSpeechSynthesizer.
@MainActor
final class TTSService: NSObject, ObservableObject {
    static let shared = TTSService()

    @Published private(set) var state: TTSState = .idle
    @Published var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    @Published var pitchMultiplier: Float = 1.0
    @Published var volume: Float = 1.0
    @Published var voiceIdentifier: String?

    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtterance: AVSpeechUtterance?

    override private init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Voice Discovery

    /// All available system voices.
    static var availableVoices: [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices()
    }

    /// Available voices for a specific language.
    static func voices(forLanguage languageCode: String) -> [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language.hasPrefix(languageCode) }
    }

    // MARK: - Playback Controls

    /// Speak the given text.
    func speak(_ text: String, language: String? = nil) {
        stop()

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = pitchMultiplier
        utterance.volume = volume

        if let identifier = voiceIdentifier,
           let voice = AVSpeechSynthesisVoice(identifier: identifier)
        {
            utterance.voice = voice
        } else if let language {
            utterance.voice = AVSpeechSynthesisVoice(language: language)
        }

        currentUtterance = utterance
        synthesizer.speak(utterance)
    }

    /// Pause speech.
    func pause() {
        guard state == .playing else { return }
        synthesizer.pauseSpeaking(at: .word)
    }

    /// Resume speech.
    func resume() {
        guard state == .paused else { return }
        synthesizer.continueSpeaking()
    }

    /// Stop speech.
    func stop() {
        guard state != .idle else { return }
        synthesizer.stopSpeaking(at: .immediate)
        currentUtterance = nil
    }

    /// Toggle between play and pause.
    func togglePlayPause(text: String, language: String? = nil) {
        switch state {
        case .idle:
            speak(text, language: language)
        case .playing:
            pause()
        case .paused:
            resume()
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension TTSService: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didStart utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in self.state = .playing }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didPause utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in self.state = .paused }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didContinue utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in self.state = .playing }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.state = .idle
            self.currentUtterance = nil
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.state = .idle
            self.currentUtterance = nil
        }
    }
}
