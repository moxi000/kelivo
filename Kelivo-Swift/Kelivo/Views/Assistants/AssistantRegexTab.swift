import SwiftUI
import SwiftData

struct AssistantRegexTab: View {
    @Environment(\.modelContext) private var modelContext

    let assistantId: String?

    @Query private var allRules: [AssistantRegex]
    @State private var showAddRule = false
    @State private var testInput = ""
    @State private var testOutput = ""
    @State private var showTestSheet = false

    /// Filter rules for the current assistant.
    private var rules: [AssistantRegex] {
        guard let assistantId else { return [] }
        return allRules.filter { $0.assistantId == assistantId }
    }

    var body: some View {
        Form {
            // MARK: - Rules List
            Section {
                ForEach(rules) { rule in
                    ruleRow(rule)
                }
                .onDelete { offsets in
                    deleteRules(at: offsets)
                }

                Button {
                    showAddRule = true
                } label: {
                    Label(String(localized: "Add Rule"), systemImage: "plus.circle")
                }
            } header: {
                Text(String(localized: "Regex Rules"))
            } footer: {
                Text(String(localized: "Define regex rules for input/output transformation."))
            }

            // MARK: - Test
            Section {
                Button {
                    showTestSheet = true
                } label: {
                    Label(String(localized: "Test Regex"), systemImage: "play")
                }
                .disabled(rules.isEmpty)
            }
        }
        .formStyle(.grouped)
        .overlay {
            if assistantId == nil {
                ContentUnavailableView {
                    Label(String(localized: "Save First"), systemImage: "textformat.abc")
                } description: {
                    Text(String(localized: "Save the assistant first to manage regex rules."))
                }
            }
        }
        .sheet(isPresented: $showAddRule) {
            NavigationStack {
                RegexRuleEditSheet(assistantId: assistantId ?? "", rule: nil)
            }
        }
        .sheet(isPresented: $showTestSheet) {
            NavigationStack {
                regexTestView
            }
        }
    }

    // MARK: - Rule Row

    private func ruleRow(_ rule: AssistantRegex) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if !rule.name.isEmpty {
                    Text(rule.name)
                        .font(.body)
                }
                Text(rule.pattern)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    ForEach(rule.scopes, id: \.self) { scope in
                        Text(scope.rawValue)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.tint.opacity(0.15), in: Capsule())
                    }
                }
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { rule.isEnabled },
                set: { rule.isEnabled = $0 }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 2)
    }

    // MARK: - Test View

    private var regexTestView: some View {
        Form {
            Section {
                TextField(String(localized: "Sample text"), text: $testInput, axis: .vertical)
                    .lineLimit(3...6)
            } header: {
                Text(String(localized: "Input"))
            }

            Section {
                Button {
                    runRegexTest()
                } label: {
                    Text(String(localized: "Run Test"))
                        .frame(maxWidth: .infinity)
                }
                .applyGlassProminentStyle()
            }

            if !testOutput.isEmpty {
                Section {
                    Text(testOutput)
                        .font(.body.monospaced())
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                } header: {
                    Text(String(localized: "Output"))
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Test Regex"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Done")) { showTestSheet = false }
            }
        }
    }

    // MARK: - Actions

    private func deleteRules(at offsets: IndexSet) {
        for index in offsets {
            let rule = rules[index]
            modelContext.delete(rule)
        }
    }

    private func runRegexTest() {
        var result = testInput
        for rule in rules where rule.isEnabled {
            guard let regex = try? NSRegularExpression(pattern: rule.pattern) else { continue }
            let range = NSRange(result.startIndex..., in: result)
            result = regex.stringByReplacingMatches(in: result, range: range, withTemplate: rule.replacement)
        }
        testOutput = result
    }
}

// MARK: - Regex Rule Edit Sheet

private struct RegexRuleEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let assistantId: String
    let rule: AssistantRegex?

    @State private var name = ""
    @State private var pattern = ""
    @State private var replacement = ""
    @State private var scopeUser = true
    @State private var scopeAssistant = false
    @State private var visualOnly = false
    @State private var replaceOnly = false

    var body: some View {
        Form {
            Section {
                TextField(String(localized: "Rule Name"), text: $name)
            } header: {
                Text(String(localized: "Name"))
            }

            Section {
                TextField(String(localized: "Pattern"), text: $pattern)
                    .font(.body.monospaced())
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif

                TextField(String(localized: "Replacement"), text: $replacement)
                    .font(.body.monospaced())
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
            } header: {
                Text(String(localized: "Pattern"))
            }

            Section {
                Toggle(String(localized: "User Input"), isOn: $scopeUser)
                Toggle(String(localized: "Assistant Output"), isOn: $scopeAssistant)
            } header: {
                Text(String(localized: "Scope"))
            }

            Section {
                Toggle(String(localized: "Visual Only"), isOn: $visualOnly)
                Toggle(String(localized: "Replace Only"), isOn: $replaceOnly)
            } header: {
                Text(String(localized: "Options"))
            }
        }
        .formStyle(.grouped)
        .navigationTitle(rule == nil ? String(localized: "New Rule") : String(localized: "Edit Rule"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Cancel")) { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "Save")) { saveRule() }
                    .disabled(pattern.isEmpty)
            }
        }
        .onAppear(perform: loadRule)
    }

    private func loadRule() {
        guard let rule else { return }
        name = rule.name
        pattern = rule.pattern
        replacement = rule.replacement
        scopeUser = rule.scopes.contains(.user)
        scopeAssistant = rule.scopes.contains(.assistant)
        visualOnly = rule.visualOnly
        replaceOnly = rule.replaceOnly
    }

    private func saveRule() {
        var scopes: [AssistantRegexScope] = []
        if scopeUser { scopes.append(.user) }
        if scopeAssistant { scopes.append(.assistant) }

        if let rule {
            rule.name = name
            rule.pattern = pattern
            rule.replacement = replacement
            rule.scopes = scopes
            rule.visualOnly = visualOnly
            rule.replaceOnly = replaceOnly
        } else {
            let newRule = AssistantRegex(
                assistantId: assistantId,
                name: name,
                pattern: pattern,
                replacement: replacement,
                scopes: scopes,
                visualOnly: visualOnly,
                replaceOnly: replaceOnly
            )
            modelContext.insert(newRule)
        }
        dismiss()
    }
}

// MARK: - Glass Style

private extension View {
    @ViewBuilder
    func applyGlassProminentStyle() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    AssistantRegexTab(assistantId: nil)
}
