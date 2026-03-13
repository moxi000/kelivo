import SwiftUI
import SwiftData

struct ModelEditView: View {
    @Bindable var model: ModelConfig

    @State private var temperature: Double = 0.7
    @State private var topP: Double = 1.0
    @State private var maxTokens: String = ""
    @State private var frequencyPenalty: Double = 0.0
    @State private var presencePenalty: Double = 0.0
    @State private var reasoningBudget: Double = 0
    @State private var customParamsJson: String = ""

    var body: some View {
        Form {
            // MARK: - Model Info
            Section {
                LabeledContent(String(localized: "Model ID")) {
                    Text(model.modelId)
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }

                TextField(String(localized: "Display Name"), text: $model.displayName)

                Toggle(String(localized: "Enabled"), isOn: $model.isEnabled)
                Toggle(String(localized: "Default Model"), isOn: $model.isDefault)
            } header: {
                Text(String(localized: "Model Info"))
            }

            // MARK: - Capabilities
            Section {
                Toggle(String(localized: "Vision"), isOn: $model.supportsVision)
                Toggle(String(localized: "Tool Use"), isOn: $model.supportsTools)
                Toggle(String(localized: "Reasoning"), isOn: $model.supportsReasoning)

                if let ctx = model.maxContextTokens {
                    LabeledContent(String(localized: "Context Window")) {
                        Text("\(ctx) tokens")
                            .monospacedDigit()
                    }
                }
                if let max = model.maxOutputTokens {
                    LabeledContent(String(localized: "Max Output")) {
                        Text("\(max) tokens")
                            .monospacedDigit()
                    }
                }
            } header: {
                Text(String(localized: "Capabilities"))
            }

            // MARK: - Parameters
            Section {
                parameterSlider(
                    title: String(localized: "Temperature"),
                    value: $temperature,
                    range: 0...2,
                    step: 0.1,
                    description: String(localized: "Controls randomness. Lower values make output more focused and deterministic.")
                )

                parameterSlider(
                    title: String(localized: "Top P"),
                    value: $topP,
                    range: 0...1,
                    step: 0.05,
                    description: String(localized: "Nucleus sampling. Considers tokens with top_p probability mass.")
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "Max Tokens"))
                        .font(.subheadline)
                    TextField(String(localized: "e.g. 4096"), text: $maxTokens)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                    Text(String(localized: "Maximum number of tokens to generate in the response."))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                parameterSlider(
                    title: String(localized: "Frequency Penalty"),
                    value: $frequencyPenalty,
                    range: -2...2,
                    step: 0.1,
                    description: String(localized: "Penalizes tokens based on their frequency in the text so far.")
                )

                parameterSlider(
                    title: String(localized: "Presence Penalty"),
                    value: $presencePenalty,
                    range: -2...2,
                    step: 0.1,
                    description: String(localized: "Penalizes tokens based on whether they appear in the text so far.")
                )
            } header: {
                Text(String(localized: "Generation Parameters"))
            }

            // MARK: - Reasoning Budget
            if model.supportsReasoning {
                Section {
                    parameterSlider(
                        title: String(localized: "Reasoning Budget"),
                        value: $reasoningBudget,
                        range: 0...32768,
                        step: 1024,
                        description: String(localized: "Maximum tokens allocated for the model's internal reasoning process.")
                    )
                } header: {
                    Text(String(localized: "Reasoning"))
                }
            }

            // MARK: - Custom Parameters
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "Custom Parameters (JSON)"))
                        .font(.subheadline)
                    TextEditor(text: $customParamsJson)
                        .font(.caption.monospaced())
                        .frame(minHeight: 100)
                        .scrollContentBackground(.hidden)
                        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
                }
            } header: {
                Text(String(localized: "Advanced"))
            } footer: {
                Text(String(localized: "Additional parameters sent with every request in JSON format."))
            }
        }
        .formStyle(.grouped)
        .navigationTitle(model.displayName.isEmpty ? model.modelId : model.displayName)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Parameter Slider

    private func parameterSlider(
        title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double,
        description: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.subheadline)
                Spacer()
                Text(String(format: "%.2f", value.wrappedValue))
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
            }
            Slider(value: value, in: range, step: step)
            Text(description)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ModelEditView(
            model: ModelConfig(
                providerId: "test",
                modelId: "gpt-4o",
                displayName: "GPT-4o",
                supportsVision: true,
                supportsTools: true
            )
        )
    }
}
