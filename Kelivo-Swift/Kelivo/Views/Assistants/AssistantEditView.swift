import SwiftUI
import SwiftData

struct AssistantEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    /// Pass nil to create a new assistant.
    let assistant: Assistant?

    @State private var name = ""
    @State private var avatar = "🤖"
    @State private var systemPrompt = ""
    @State private var chatModelProvider: String?
    @State private var chatModelId: String?
    @State private var temperature: Double?
    @State private var topP: Double?
    @State private var maxTokens: Int?
    @State private var thinkingBudget: Int?
    @State private var streamOutput = true
    @State private var contextMessageSize = 64
    @State private var limitContextMessages = true
    @State private var enableMemory = false
    @State private var mcpServerIds: [String] = []
    @State private var customHeadersJson = ""
    @State private var customBodyJson = ""

    @State private var selectedTab = 0

    private var isNewAssistant: Bool { assistant == nil }

    var body: some View {
        TabView(selection: $selectedTab) {
            // MARK: - Tab: Basic
            basicTab
                .tabItem { Label(String(localized: "Basic"), systemImage: "person") }
                .tag(0)

            // MARK: - Tab: System Prompt
            systemPromptTab
                .tabItem { Label(String(localized: "System Prompt"), systemImage: "text.alignleft") }
                .tag(1)

            // MARK: - Tab: Quick Phrases
            quickPhrasesTab
                .tabItem { Label(String(localized: "Quick Phrases"), systemImage: "text.bubble") }
                .tag(2)

            // MARK: - Tab: MCP
            mcpTab
                .tabItem { Label(String(localized: "MCP"), systemImage: "point.3.connected.trianglepath.dotted") }
                .tag(3)

            // MARK: - Tab: Memory
            memoryTab
                .tabItem { Label(String(localized: "Memory"), systemImage: "brain") }
                .tag(4)

            // MARK: - Tab: Regex
            regexTab
                .tabItem { Label(String(localized: "Regex"), systemImage: "textformat.abc") }
                .tag(5)

            // MARK: - Tab: Custom Request
            customRequestTab
                .tabItem { Label(String(localized: "Custom"), systemImage: "slider.horizontal.3") }
                .tag(6)
        }
        .navigationTitle(isNewAssistant ? String(localized: "New Assistant") : name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            if isNewAssistant {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save")) { saveNewAssistant() }
                        .disabled(name.isEmpty)
                }
            }
        }
        .onAppear(perform: loadAssistant)
    }

    // MARK: - Basic Tab

    private var basicTab: some View {
        Form {
            Section {
                HStack {
                    Text(String(localized: "Avatar"))
                    Spacer()
                    TextField("🤖", text: $avatar)
                        .multilineTextAlignment(.center)
                        .frame(width: 60)
                }

                TextField(String(localized: "Name"), text: $name)
            } header: {
                Text(String(localized: "Identity"))
            }

            Section {
                Picker(String(localized: "Provider"), selection: $chatModelProvider) {
                    Text(String(localized: "Default")).tag(nil as String?)
                    // Provider options would be populated from SwiftData query
                }

                TextField(String(localized: "Model ID"), text: Binding(
                    get: { chatModelId ?? "" },
                    set: { chatModelId = $0.isEmpty ? nil : $0 }
                ))
                .autocorrectionDisabled()
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
            } header: {
                Text(String(localized: "Model"))
            }

            Section {
                Toggle(String(localized: "Stream Output"), isOn: $streamOutput)
                Toggle(String(localized: "Limit Context Messages"), isOn: $limitContextMessages)

                if limitContextMessages {
                    Stepper(
                        String(localized: "Context Size: \(contextMessageSize)"),
                        value: $contextMessageSize,
                        in: 1...256
                    )
                }
            } header: {
                Text(String(localized: "Behavior"))
            }
        }
        .formStyle(.grouped)
    }

    // MARK: - System Prompt Tab

    private var systemPromptTab: some View {
        VStack {
            TextEditor(text: $systemPrompt)
                .font(.body)
                .scrollContentBackground(.hidden)
                .padding()
                .background(Color.surfaceSecondary, in: RoundedRectangle(cornerRadius: 12))
                .padding()
        }
    }

    // MARK: - Quick Phrases Tab

    private var quickPhrasesTab: some View {
        Group {
            if let assistant {
                QuickPhrasesView(assistantId: assistant.id)
            } else {
                ContentUnavailableView {
                    Label(String(localized: "Save First"), systemImage: "text.bubble")
                } description: {
                    Text(String(localized: "Save the assistant first to manage quick phrases."))
                }
            }
        }
    }

    // MARK: - MCP Tab

    private var mcpTab: some View {
        Form {
            Section {
                Text(String(localized: "Select MCP servers to enable for this assistant."))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                // MCP server list would be populated from available servers
            } header: {
                Text(String(localized: "MCP Servers"))
            }
        }
        .formStyle(.grouped)
    }

    // MARK: - Memory Tab

    private var memoryTab: some View {
        Form {
            Section {
                Toggle(String(localized: "Enable Memory"), isOn: $enableMemory)
            } header: {
                Text(String(localized: "Memory"))
            } footer: {
                Text(String(localized: "When enabled, the assistant will remember information across conversations."))
            }

            if enableMemory, let assistant {
                Section {
                    Text(String(localized: "Memory entries for this assistant will appear here."))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    // Memory entries from AssistantMemory where assistantId == assistant.id
                } header: {
                    Text(String(localized: "Memories"))
                }
            }
        }
        .formStyle(.grouped)
    }

    // MARK: - Regex Tab

    private var regexTab: some View {
        Form {
            Section {
                Text(String(localized: "Define regex rules for input/output transformation."))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                // Regex rules from AssistantRegex where assistantId == assistant.id
            } header: {
                Text(String(localized: "Regex Rules"))
            }
        }
        .formStyle(.grouped)
    }

    // MARK: - Custom Request Tab

    private var customRequestTab: some View {
        Form {
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
            } header: {
                Text(String(localized: "Custom Headers"))
            }

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
            } header: {
                Text(String(localized: "Custom Body"))
            }
        }
        .formStyle(.grouped)
    }

    // MARK: - Load / Save

    private func loadAssistant() {
        guard let assistant else { return }
        name = assistant.name
        avatar = assistant.avatar ?? "🤖"
        systemPrompt = assistant.systemPrompt
        chatModelProvider = assistant.chatModelProvider
        chatModelId = assistant.chatModelId
        temperature = assistant.temperature
        topP = assistant.topP
        maxTokens = assistant.maxTokens
        thinkingBudget = assistant.thinkingBudget
        streamOutput = assistant.streamOutput
        contextMessageSize = assistant.contextMessageSize
        limitContextMessages = assistant.limitContextMessages
        enableMemory = assistant.enableMemory
        mcpServerIds = assistant.mcpServerIds
        customHeadersJson = assistant.customHeadersJson ?? ""
        customBodyJson = assistant.customBodyJson ?? ""
    }

    private func saveNewAssistant() {
        let newAssistant = Assistant(
            name: name,
            avatar: avatar,
            chatModelProvider: chatModelProvider,
            chatModelId: chatModelId,
            temperature: temperature,
            topP: topP,
            contextMessageSize: contextMessageSize,
            limitContextMessages: limitContextMessages,
            streamOutput: streamOutput,
            thinkingBudget: thinkingBudget,
            maxTokens: maxTokens,
            systemPrompt: systemPrompt,
            mcpServerIds: mcpServerIds,
            enableMemory: enableMemory,
            customHeadersJson: customHeadersJson.isEmpty ? nil : customHeadersJson,
            customBodyJson: customBodyJson.isEmpty ? nil : customBodyJson
        )
        modelContext.insert(newAssistant)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AssistantEditView(assistant: nil)
    }
}
