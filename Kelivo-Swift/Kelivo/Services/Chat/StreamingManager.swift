import Foundation

// MARK: - Streaming Manager

/// Manages active streaming sessions keyed by conversation ID.
///
/// Only one streaming session per conversation is allowed. Starting a new
/// session for the same conversation automatically cancels the previous one.
actor StreamingManager {
    private var activeSessions: [String: Task<Void, Never>] = [:]

    /// Start a streaming session for the given conversation.
    ///
    /// If a session already exists for this conversation, it is cancelled first.
    func startSession(conversationId: String, task: Task<Void, Never>) {
        activeSessions[conversationId]?.cancel()
        activeSessions[conversationId] = task
    }

    /// Stop the streaming session for a specific conversation.
    func stopSession(conversationId: String) {
        activeSessions[conversationId]?.cancel()
        activeSessions.removeValue(forKey: conversationId)
    }

    /// Stop all active streaming sessions.
    func stopAll() {
        for (_, task) in activeSessions {
            task.cancel()
        }
        activeSessions.removeAll()
    }

    /// Check whether a streaming session is active for the given conversation.
    func isActive(conversationId: String) -> Bool {
        activeSessions[conversationId] != nil
    }

    /// Number of currently active streaming sessions.
    var activeCount: Int {
        activeSessions.count
    }

    /// Remove the session entry without cancelling the task.
    ///
    /// Use this when the task has already completed naturally and you want
    /// to clean up the session registry.
    func removeSession(conversationId: String) {
        activeSessions.removeValue(forKey: conversationId)
    }
}
