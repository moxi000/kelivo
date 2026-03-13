import Foundation
import OSLog

// MARK: - Log Category

enum LogCategory: String, CaseIterable, Sendable {
    case network
    case chat
    case mcp
    case storage
    case ui
    case tts
    case search
    case backup
    case general

    var osLogger: Logger {
        Logger(subsystem: AppLogger.subsystem, category: rawValue)
    }
}

// MARK: - App Logger

/// Centralized logging wrapper around os.Logger with optional file logging.
final class AppLogger: Sendable {
    static let subsystem = Bundle.main.bundleIdentifier ?? "com.kelivo.app"
    static let shared = AppLogger()

    /// Enable or disable file logging. Thread-safe access via lock.
    private let _fileLoggingEnabled: LockedValue<Bool>
    private let _logFileURL: LockedValue<URL?>

    var fileLoggingEnabled: Bool {
        get { _fileLoggingEnabled.value }
        set { _fileLoggingEnabled.value = newValue }
    }

    private init() {
        _fileLoggingEnabled = LockedValue(false)
        _logFileURL = LockedValue(nil)
    }

    // MARK: - Log Methods

    func debug(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        category.osLogger.debug("\(message, privacy: .public)")
        writeToFileIfEnabled(level: "DEBUG", category: category, message: message, file: file, function: function, line: line)
    }

    func info(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        category.osLogger.info("\(message, privacy: .public)")
        writeToFileIfEnabled(level: "INFO", category: category, message: message, file: file, function: function, line: line)
    }

    func warning(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        category.osLogger.warning("\(message, privacy: .public)")
        writeToFileIfEnabled(level: "WARNING", category: category, message: message, file: file, function: function, line: line)
    }

    func error(_ message: String, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        category.osLogger.error("\(message, privacy: .public)")
        writeToFileIfEnabled(level: "ERROR", category: category, message: message, file: file, function: function, line: line)
    }

    func error(_ error: Error, category: LogCategory = .general, file: String = #file, function: String = #function, line: Int = #line) {
        let message = error.localizedDescription
        category.osLogger.error("\(message, privacy: .public)")
        writeToFileIfEnabled(level: "ERROR", category: category, message: message, file: file, function: function, line: line)
    }

    // MARK: - File Logging

    /// Enable file logging and set the output file URL.
    func enableFileLogging(at url: URL? = nil) {
        let logURL = url ?? defaultLogFileURL()
        _logFileURL.value = logURL
        _fileLoggingEnabled.value = true

        // Create file if it doesn't exist
        if let logURL = _logFileURL.value {
            FileManager.default.createFile(atPath: logURL.path, contents: nil)
        }

        info("File logging enabled at: \(logURL?.path ?? "unknown")", category: .general)
    }

    /// Disable file logging.
    func disableFileLogging() {
        _fileLoggingEnabled.value = false
        info("File logging disabled", category: .general)
    }

    /// Get the current log file data for export.
    func exportLogData() -> Data? {
        guard let url = _logFileURL.value else { return nil }
        return try? Data(contentsOf: url)
    }

    /// Clear the log file.
    func clearLogFile() {
        guard let url = _logFileURL.value else { return }
        try? Data().write(to: url)
    }

    /// Get the log file URL.
    func logFileURL() -> URL? {
        _logFileURL.value
    }

    // MARK: - Private

    private func defaultLogFileURL() -> URL {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDir.appendingPathComponent("kelivo-app.log")
    }

    private func writeToFileIfEnabled(
        level: String,
        category: LogCategory,
        message: String,
        file: String,
        function: String,
        line: Int
    ) {
        guard _fileLoggingEnabled.value, let url = _logFileURL.value else { return }

        let timestamp = ISO8601DateFormatter().string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let entry = "[\(timestamp)] [\(level)] [\(category.rawValue)] \(fileName):\(line) \(function) - \(message)\n"

        guard let data = entry.data(using: .utf8) else { return }

        // Append to file
        if let handle = try? FileHandle(forWritingTo: url) {
            handle.seekToEndOfFile()
            handle.write(data)
            handle.closeFile()
        }
    }
}

// MARK: - Thread-Safe Value Wrapper

/// A simple lock-based thread-safe value wrapper.
private final class LockedValue<T>: @unchecked Sendable {
    private var _value: T
    private let lock = NSLock()

    init(_ value: T) {
        _value = value
    }

    var value: T {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
}

// MARK: - Convenience Global Functions

/// Shorthand for AppLogger.shared
let appLog = AppLogger.shared
