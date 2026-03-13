import AVFoundation
import Foundation

// MARK: - Network TTS Provider

enum NetworkTTSProvider: String, Sendable, Codable {
    case openai
    case azure
}

// MARK: - Network TTS Configuration

struct NetworkTTSConfig: Sendable, Codable {
    let provider: NetworkTTSProvider
    let apiKey: String
    let endpoint: String?
    let voice: String
    let model: String?
    let speed: Double

    init(
        provider: NetworkTTSProvider,
        apiKey: String,
        endpoint: String? = nil,
        voice: String = "alloy",
        model: String? = nil,
        speed: Double = 1.0
    ) {
        self.provider = provider
        self.apiKey = apiKey
        self.endpoint = endpoint
        self.voice = voice
        self.model = model
        self.speed = speed
    }
}

// MARK: - Network TTS Error

enum NetworkTTSError: Error, LocalizedError {
    case notConfigured
    case requestFailed(String)
    case playbackFailed(String)
    case unsupportedProvider

    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Network TTS is not configured"
        case let .requestFailed(detail):
            return "TTS request failed: \(detail)"
        case let .playbackFailed(detail):
            return "TTS playback failed: \(detail)"
        case .unsupportedProvider:
            return "Unsupported TTS provider"
        }
    }
}

// MARK: - Network TTS Service

@MainActor
final class NetworkTTSService: ObservableObject {
    static let shared = NetworkTTSService()

    @Published private(set) var isPlaying = false
    @Published private(set) var isLoading = false
    @Published var config: NetworkTTSConfig?

    private var audioPlayer: AVAudioPlayer?
    private var currentTask: Task<Void, Never>?

    private init() {}

    // MARK: - Voice Options

    static let openAIVoices = ["alloy", "ash", "coral", "echo", "fable", "onyx", "nova", "sage", "shimmer"]
    static let openAIModels = ["tts-1", "tts-1-hd", "gpt-4o-mini-tts"]

    // MARK: - Playback

    /// Synthesize and play text using the configured network TTS provider.
    func speak(_ text: String) {
        stop()

        currentTask = Task {
            guard let config else {
                return
            }

            isLoading = true
            defer { isLoading = false }

            do {
                let audioData: Data
                switch config.provider {
                case .openai:
                    audioData = try await requestOpenAI(text: text, config: config)
                case .azure:
                    audioData = try await requestAzure(text: text, config: config)
                }

                guard !Task.isCancelled else { return }

                try playAudioData(audioData)
            } catch {
                if !Task.isCancelled {
                    isPlaying = false
                }
            }
        }
    }

    /// Stop playback.
    func stop() {
        currentTask?.cancel()
        currentTask = nil
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }

    // MARK: - OpenAI TTS

    private func requestOpenAI(text: String, config: NetworkTTSConfig) async throws -> Data {
        let endpoint = config.endpoint ?? "https://api.openai.com/v1/audio/speech"
        guard let url = URL(string: endpoint) else {
            throw NetworkTTSError.requestFailed("Invalid endpoint URL")
        }

        let model = config.model ?? "tts-1"

        let body: [String: Any] = [
            "model": model,
            "input": text,
            "voice": config.voice,
            "speed": config.speed,
            "response_format": "mp3",
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await HTTPClient.shared.request(
            url,
            method: "POST",
            headers: [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(config.apiKey)",
            ],
            body: bodyData
        )

        return data
    }

    // MARK: - Azure TTS

    private func requestAzure(text: String, config: NetworkTTSConfig) async throws -> Data {
        guard let endpoint = config.endpoint else {
            throw NetworkTTSError.requestFailed("Azure TTS endpoint is required")
        }

        guard let url = URL(string: endpoint) else {
            throw NetworkTTSError.requestFailed("Invalid Azure endpoint URL")
        }

        let ssml = """
            <speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='en-US'>
                <voice name='\(config.voice)'>
                    <prosody rate='\(config.speed)'>
                        \(text.xmlEscaped)
                    </prosody>
                </voice>
            </speak>
            """

        guard let bodyData = ssml.data(using: .utf8) else {
            throw NetworkTTSError.requestFailed("Failed to encode SSML")
        }

        let (data, _) = try await HTTPClient.shared.request(
            url,
            method: "POST",
            headers: [
                "Content-Type": "application/ssml+xml",
                "Ocp-Apim-Subscription-Key": config.apiKey,
                "X-Microsoft-OutputFormat": "audio-16khz-128kbitrate-mono-mp3",
            ],
            body: bodyData
        )

        return data
    }

    // MARK: - Audio Playback

    private func playAudioData(_ data: Data) throws {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.play()
            isPlaying = true
        } catch {
            throw NetworkTTSError.playbackFailed(error.localizedDescription)
        }
    }
}

// MARK: - String XML Escaping

private extension String {
    var xmlEscaped: String {
        self.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&apos;")
    }
}
