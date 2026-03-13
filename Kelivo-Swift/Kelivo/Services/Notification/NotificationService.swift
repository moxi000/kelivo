import Foundation
import UserNotifications

// MARK: - Notification Error

enum NotificationError: Error, LocalizedError {
    case permissionDenied
    case scheduleFailed(String)

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Notification permission was denied"
        case let .scheduleFailed(detail):
            return "Failed to schedule notification: \(detail)"
        }
    }
}

// MARK: - Notification Service

@MainActor
final class NotificationService: NSObject, ObservableObject {
    static let shared = NotificationService()

    @Published private(set) var isAuthorized = false
    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private let center = UNUserNotificationCenter.current()

    override private init() {
        super.init()
        center.delegate = self
        Task { await refreshAuthorizationStatus() }
    }

    // MARK: - Permission

    /// Request notification permission.
    func requestPermission() async throws -> Bool {
        let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        await refreshAuthorizationStatus()
        if !granted {
            throw NotificationError.permissionDenied
        }
        return granted
    }

    /// Refresh the current authorization status.
    func refreshAuthorizationStatus() async {
        let settings = await center.notificationSettings()
        authorizationStatus = settings.authorizationStatus
        isAuthorized = settings.authorizationStatus == .authorized
    }

    // MARK: - Schedule Notifications

    /// Schedule a local notification with the given content after a delay.
    func scheduleNotification(
        id: String = UUID().uuidString,
        title: String,
        body: String,
        subtitle: String? = nil,
        delay: TimeInterval = 0,
        categoryIdentifier: String? = nil,
        userInfo: [String: Any] = [:]
    ) async throws {
        guard isAuthorized else {
            throw NotificationError.permissionDenied
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if let subtitle { content.subtitle = subtitle }
        content.sound = .default
        content.userInfo = userInfo
        if let categoryIdentifier { content.categoryIdentifier = categoryIdentifier }

        let trigger: UNNotificationTrigger?
        if delay > 0 {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        } else {
            trigger = nil
        }

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        do {
            try await center.add(request)
        } catch {
            throw NotificationError.scheduleFailed(error.localizedDescription)
        }
    }

    /// Schedule a notification for when a chat response is complete.
    func notifyChatComplete(conversationTitle: String, preview: String) async throws {
        try await scheduleNotification(
            title: conversationTitle,
            body: String(preview.prefix(200)),
            categoryIdentifier: "CHAT_RESPONSE"
        )
    }

    // MARK: - Cancel Notifications

    /// Cancel a pending notification by ID.
    func cancelNotification(id: String) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    /// Cancel all pending notifications.
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }

    /// Remove all delivered notifications.
    func removeAllDelivered() {
        center.removeAllDeliveredNotifications()
    }

    // MARK: - Notification Categories

    /// Register notification categories for action buttons.
    func registerCategories() {
        let replyAction = UNNotificationAction(
            identifier: "REPLY_ACTION",
            title: "Reply",
            options: .foreground
        )

        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: "Dismiss",
            options: .destructive
        )

        let chatCategory = UNNotificationCategory(
            identifier: "CHAT_RESPONSE",
            actions: [replyAction, dismissAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )

        center.setNotificationCategories([chatCategory])
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    /// Handle notifications when the app is in the foreground.
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }

    /// Handle notification actions.
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let actionIdentifier = response.actionIdentifier
        let userInfo = response.notification.request.content.userInfo

        switch actionIdentifier {
        case "REPLY_ACTION":
            // Post a notification for the app to handle navigation
            await MainActor.run {
                NotificationCenter.default.post(
                    name: .init("NotificationReplyAction"),
                    object: nil,
                    userInfo: userInfo
                )
            }
        case UNNotificationDefaultActionIdentifier:
            // User tapped the notification
            await MainActor.run {
                NotificationCenter.default.post(
                    name: .init("NotificationTapped"),
                    object: nil,
                    userInfo: userInfo
                )
            }
        default:
            break
        }
    }
}
