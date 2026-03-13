import AVFoundation
import Foundation
import Observation

@Observable
final class TTSViewModel: NSObject {

    // MARK: - Nested Types

    struct VoiceInfo: Identifiable, Sendable {
        let id: String
        let name: String
        let language: String
    }

    // MARK: Published State

    var isPlaying: Bool = false
    var selectedVoice: String?
    var rate: Float = 0.5
    var pitch: Float = 1.0
    var useNetworkTTS: Bool = false
    var networkTTSProvider: String?
    var networkTTSVoice: String?

    // MARK: Private

    private let synthesizer = AVSpeechSynthesizer()
    private var networkTask: Task<Void, Never>?

    // MARK: Init

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Playback

    func speak(_ text: String) async {
        guard !text.isEmpty else { return }
        stop()

        if useNetworkTTS {
            await speakWithNetwork(text)
        } else {
            speakWithSystem(text)
        }
    }

    func stop() {
        networkTask?.cancel()
        networkTask = nil

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isPlaying = false
    }

    func pause() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .word)
        }
        isPlaying = false
    }

    func resume() {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            isPlaying = true
        }
    }

    // MARK: - Voice Discovery

    func availableVoices() -> [VoiceInfo] {
        AVSpeechSynthesisVoice.speechVoices().map { voice in
            VoiceInfo(
                id: voice.identifier,
                name: voice.name,
                language: voice.language
            )
        }
    }

    // MARK: - Private

    private func speakWithSystem(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)

        // Rate: AVSpeechUtterance expects 0.0–1.0, default ~0.5
        utterance.rate = rate
        utterance.pitchMultiplier = pitch

        if let voiceId = selectedVoice {
            utterance.voice = AVSpeechSynthesisVoice(identifier: voiceId)
        }

        isPlaying = true
        synthesizer.speak(utterance)
    }

    private func speakWithNetwork(_ text: String) async {
        isPlaying = true

        networkTask = Task {
            // TODO: Implement network TTS
            // 1. Call the network TTS provider API (e.g., OpenAI TTS, Azure, etc.)
            //    using networkTTSProvider and networkTTSVoice
            // 2. Receive audio data
            // 3. Play using AVAudioPlayer or AVAudioEngine
            _ = text

            await MainActor.run {
                isPlaying = false
            }
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension TTSViewModel: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        isPlaying = false
    }

    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        isPlaying = false
    }
}
