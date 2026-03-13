import Foundation

extension String {
    /// Returns `true` if the string is empty or contains only whitespace characters.
    var isBlank: Bool {
        allSatisfy(\.isWhitespace)
    }

    /// Returns a truncated copy of the string, appending "..." if it exceeds the given length.
    func truncated(to length: Int) -> String {
        guard length >= 0 else { return "" }
        if count <= length {
            return self
        }
        return String(prefix(length)) + "..."
    }
}
