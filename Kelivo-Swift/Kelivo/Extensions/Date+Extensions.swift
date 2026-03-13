import Foundation

extension Date {
    /// Returns a localized relative time string (e.g., "2 hours ago", "yesterday").
    func relativeFormatted() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: .now)
    }

    /// Returns a short formatted date string (e.g., "Mar 13, 2026").
    func shortFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
