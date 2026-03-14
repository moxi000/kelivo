import SwiftUI

struct AssistantCustomRequestTab: View {
    @Binding var customHeadersJson: String
    @Binding var customBodyJson: String
    @Binding var temperature: Double?
    @Binding var topP: Double?
    @Binding var maxTokens: Int?

    @State private var showHeadersEditor = false
    @State private var showBodyEditor = false

    var body: some View {
        Form {
            // MARK: - Parameter Overrides
            Section {
                optionalSlider(
                    title: String(localized: "Temperature"),
                    value: $temperature,
                    range: 0...2,
                    step: 0.1,
                    format: "%.1f"
                )

                optionalSlider(
                    title: String(localized: "Top P"),
                    value: $topP,
                    range: 0...1,
                    step: 0.05,
                    format: "%.2f"
                )

                HStack {
                    Text(String(localized: "Max Tokens"))
                    Spacer()
                    TextField(
                        String(localized: "Default"),
                        value: $maxTokens,
                        format: .number
                    )
                    .multilineTextAlignment(.trailing)
                    .frame(width: 100)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
                }
            } header: {
                Text(String(localized: "Parameter Overrides"))
            } footer: {
                Text(String(localized: "Leave empty to use the provider's default values."))
            }

            // MARK: - Custom Headers
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "Custom Headers (JSON)"))
                        .font(.subheadline)
                    TextEditor(text: $customHeadersJson)
                        .font(.caption.monospaced())
                        .frame(minHeight: 80)
                        .scrollContentBackground(.hidden)
                        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
                }

                Button {
                    showHeadersEditor = true
                } label: {
                    Label(String(localized: "Open Full Editor"), systemImage: "arrow.up.right.square")
                        .font(.caption)
                }
            } header: {
                Text(String(localized: "Custom Headers"))
            }

            // MARK: - Custom Body
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "Custom Body Parameters (JSON)"))
                        .font(.subheadline)
                    TextEditor(text: $customBodyJson)
                        .font(.caption.monospaced())
                        .frame(minHeight: 80)
                        .scrollContentBackground(.hidden)
                        .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 8))
                }

                Button {
                    showBodyEditor = true
                } label: {
                    Label(String(localized: "Open Full Editor"), systemImage: "arrow.up.right.square")
                        .font(.caption)
                }
            } header: {
                Text(String(localized: "Custom Body"))
            }
        }
        .formStyle(.grouped)
        .sheet(isPresented: $showHeadersEditor) {
            NavigationStack {
                MCPJsonEditView(
                    title: String(localized: "Custom Headers"),
                    json: customHeadersJson
                ) { json in
                    customHeadersJson = json
                }
            }
        }
        .sheet(isPresented: $showBodyEditor) {
            NavigationStack {
                MCPJsonEditView(
                    title: String(localized: "Custom Body"),
                    json: customBodyJson
                ) { json in
                    customBodyJson = json
                }
            }
        }
    }

    // MARK: - Optional Slider

    private func optionalSlider(
        title: String,
        value: Binding<Double?>,
        range: ClosedRange<Double>,
        step: Double,
        format: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                if let v = value.wrappedValue {
                    Text(String(format: format, v))
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                } else {
                    Text(String(localized: "Default"))
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Button {
                    if value.wrappedValue != nil {
                        value.wrappedValue = nil
                    } else {
                        value.wrappedValue = (range.lowerBound + range.upperBound) / 2
                    }
                } label: {
                    Image(systemName: value.wrappedValue != nil ? "xmark.circle.fill" : "plus.circle")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            if let current = value.wrappedValue {
                Slider(
                    value: Binding(
                        get: { current },
                        set: { value.wrappedValue = $0 }
                    ),
                    in: range,
                    step: step
                )
            }
        }
    }
}

#Preview {
    AssistantCustomRequestTab(
        customHeadersJson: .constant(""),
        customBodyJson: .constant(""),
        temperature: .constant(nil),
        topP: .constant(nil),
        maxTokens: .constant(nil)
    )
}
