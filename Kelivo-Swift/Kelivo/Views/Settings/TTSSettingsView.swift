import AVFoundation
import SwiftUI

struct TTSSettingsView: View {
    @State private var tts = TTSViewModel()

    // MARK: - System TTS

    @State private var useSystemTTS: Bool = true
    @State private var selectedVoiceId: String = ""
    @State private var speechRate: Float = 0.5
    @State private var pitch: Float = 1.0
    @State private var autoRead: Bool = false

    // MARK: - Network TTS

    @State private var networkEndpoint: String = ""
    @State private var networkApiKey: String = ""
    @State private var networkVoiceId: String = ""

    var body: some View {
        Form {
            // MARK: - General

            Section {
                Toggle(String(localized: "Auto-Read Responses"), isOn: $autoRead)
            } header: {
                Text(String(localized: "General"))
            } footer: {
                Text(String(localized: "Automatically read aloud new assistant responses."))
            }

            // MARK: - System TTS

            Section {
                Toggle(String(localized: "Use System TTS"), isOn: $useSystemTTS)

                if useSystemTTS {
                    Picker(String(localized: "Voice"), selection: $selectedVoiceId) {
                        Text(String(localized: "System Default")).tag("")
                        ForEach(tts.availableVoices()) { voice in
                            Text("\(voice.name) (\(voice.language))")
                                .tag(voice.id)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(String(localized: "Speech Rate"))
                            Spacer()
                            Text(String(format: "%.2f", speechRate))
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                        Slider(value: $speechRate, in: 0.0...1.0, step: 0.05)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(String(localized: "Pitch"))
                            Spacer()
                            Text(String(format: "%.2f", pitch))
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                        Slider(value: $pitch, in: 0.5...2.0, step: 0.05)
                    }
                }
            } header: {
                Text(String(localized: "System TTS"))
            }

            // MARK: - Network TTS

            Section {
                if useSystemTTS {
                    Text(String(localized: "Disable System TTS above to use Network TTS."))
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                } else {
                    TextField(String(localized: "API Endpoint"), text: $networkEndpoint)
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                        .autocorrectionDisabled()

                    SecureField(String(localized: "API Key"), text: $networkApiKey)
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                        .autocorrectionDisabled()

                    TextField(String(localized: "Voice ID"), text: $networkVoiceId)
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        #endif
                        .autocorrectionDisabled()
                }
            } header: {
                Text(String(localized: "Network TTS"))
            } footer: {
                if !useSystemTTS {
                    Text(String(localized: "Configure a remote TTS service endpoint for higher quality speech synthesis."))
                }
            }

            // MARK: - Test

            Section {
                Button {
                    testSpeech()
                } label: {
                    HStack {
                        Image(systemName: tts.isPlaying ? "stop.circle" : "play.circle")
                        Text(tts.isPlaying
                            ? String(localized: "Stop")
                            : String(localized: "Test Speech"))
                    }
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Text to Speech"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear(perform: loadSettings)
    }

    // MARK: - Actions

    private func testSpeech() {
        if tts.isPlaying {
            tts.stop()
            return
        }

        tts.selectedVoice = selectedVoiceId.isEmpty ? nil : selectedVoiceId
        tts.rate = speechRate
        tts.pitch = pitch
        tts.useNetworkTTS = !useSystemTTS
        tts.networkTTSVoice = networkVoiceId.isEmpty ? nil : networkVoiceId

        let sampleText = String(localized: "This is a test of the text to speech system.")
        Task {
            await tts.speak(sampleText)
        }
    }

    private func loadSettings() {
        let defaults = UserDefaults.standard
        useSystemTTS = !defaults.bool(forKey: "tts.useNetworkTTS")
        selectedVoiceId = defaults.string(forKey: "tts.selectedVoice") ?? ""
        speechRate = defaults.float(forKey: "tts.rate").nonZeroOr(0.5)
        pitch = defaults.float(forKey: "tts.pitch").nonZeroOr(1.0)
        autoRead = defaults.bool(forKey: "tts.autoRead")
        networkEndpoint = defaults.string(forKey: "tts.networkEndpoint") ?? ""
        networkApiKey = defaults.string(forKey: "tts.networkApiKey") ?? ""
        networkVoiceId = defaults.string(forKey: "tts.networkVoiceId") ?? ""
    }
}

// MARK: - Helpers

private extension Float {
    func nonZeroOr(_ fallback: Float) -> Float {
        self == 0 ? fallback : self
    }
}

#Preview {
    NavigationStack {
        TTSSettingsView()
    }
}
