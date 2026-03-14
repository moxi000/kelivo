import Foundation

/// Manages learning mode state, where the assistant asks clarifying questions
/// and builds understanding over time.
actor LearningModeService {
    static let shared = LearningModeService()
    private init() {}

    private var isEnabled: Bool = false
    private var learningPromptTemplate: String = ""

    /// Whether learning mode is currently active.
    func getIsEnabled() -> Bool {
        isEnabled
    }

    /// Enable or disable learning mode.
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "learningModeEnabled")
    }

    /// Get the learning prompt to prepend to user messages when learning mode is active.
    func getLearningPrompt() -> String? {
        guard isEnabled else { return nil }
        let stored = UserDefaults.standard.string(forKey: "learningModePrompt") ?? ""
        return stored.isEmpty ? defaultLearningPrompt : stored
    }

    /// Set a custom learning prompt template.
    func setLearningPrompt(_ prompt: String) {
        learningPromptTemplate = prompt
        UserDefaults.standard.set(prompt, forKey: "learningModePrompt")
    }

    /// Load stored state from UserDefaults.
    func loadState() {
        isEnabled = UserDefaults.standard.bool(forKey: "learningModeEnabled")
        learningPromptTemplate = UserDefaults.standard.string(forKey: "learningModePrompt") ?? ""
    }

    private var defaultLearningPrompt: String {
        """
        Before answering, consider if you need more context. If the question is ambiguous \
        or could benefit from clarification, ask a brief clarifying question first. \
        Focus on understanding the user's intent accurately.
        """
    }
}
