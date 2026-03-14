import Foundation

// MARK: - Request Log Entry

struct RequestLogEntry: Sendable {
    let id: Int
    let timestamp: Date
    let method: String
    let url: String
    let requestHeaders: [String: String]
    let requestBody: String?
    let statusCode: Int?
    let responseHeaders: [String: String]?
    let responseBody: String?
    let duration: TimeInterval?
    let error: String?
}

// MARK: - Request Logger

/// Thread-safe HTTP request/response logger with circular buffer and file output.
actor RequestLogger {
    static let shared = RequestLogger()

    private var isEnabled = false
    private var entries: [RequestLogEntry] = []
    private var nextId = 1
    private let maxEntries = 500

    // File logging
    private var fileHandle: FileHandle?
    private var currentLogDate: String?

    // MARK: - Enable / Disable

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        if !enabled {
            closeFileHandle()
        }
    }

    var enabled: Bool { isEnabled }

    // MARK: - Logging

    /// Generate the next request ID.
    func nextRequestId() -> Int {
        let id = nextId
        nextId += 1
        return id
    }

    /// Log a request/response entry.
    func log(_ entry: RequestLogEntry) {
        guard isEnabled else { return }

        entries.append(entry)
        if entries.count > maxEntries {
            entries.removeFirst(entries.count - maxEntries)
        }

        writeToFile(entry)
    }

    /// Log a simple text line.
    func logLine(_ line: String) {
        guard isEnabled else { return }

        let entry = RequestLogEntry(
            id: nextRequestId(),
            timestamp: .now,
            method: "-",
            url: "-",
            requestHeaders: [:],
            requestBody: nil,
            statusCode: nil,
            responseHeaders: nil,
            responseBody: line,
            duration: nil,
            error: nil
        )

        entries.append(entry)
        if entries.count > maxEntries {
            entries.removeFirst(entries.count - maxEntries)
        }

        writeLineToFile(formatTimestamp(.now) + " " + line)
    }

    // MARK: - Query

    /// Return all logged entries.
    func allEntries() -> [RequestLogEntry] {
        entries
    }

    /// Return entries filtered by status code.
    func entries(withStatusCode code: Int) -> [RequestLogEntry] {
        entries.filter { $0.statusCode == code }
    }

    /// Return entries matching a URL pattern.
    func entries(matchingURL pattern: String) -> [RequestLogEntry] {
        entries.filter { $0.url.contains(pattern) }
    }

    /// Return the most recent N entries.
    func recentEntries(count: Int = 50) -> [RequestLogEntry] {
        Array(entries.suffix(count))
    }

    /// Clear all in-memory entries.
    func clear() {
        entries.removeAll()
    }

    // MARK: - File Output

    private func writeToFile(_ entry: RequestLogEntry) {
        let ts = formatTimestamp(entry.timestamp)
        var lines: [String] = []
        lines.append("[\(ts)] \(entry.method) \(entry.url)")

        if !entry.requestHeaders.isEmpty {
            let headersStr = entry.requestHeaders.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            lines.append("  Request Headers: \(headersStr)")
        }

        if let body = entry.requestBody {
            let truncated = truncate(body, maxLength: 2000)
            lines.append("  Request Body: \(truncated)")
        }

        if let statusCode = entry.statusCode {
            lines.append("  Response: \(statusCode)")
        }

        if let responseBody = entry.responseBody {
            let truncated = truncate(responseBody, maxLength: 2000)
            lines.append("  Response Body: \(truncated)")
        }

        if let duration = entry.duration {
            lines.append("  Duration: \(String(format: "%.3f", duration))s")
        }

        if let error = entry.error {
            lines.append("  Error: \(error)")
        }

        let text = lines.joined(separator: "\n") + "\n"
        writeLineToFile(text)
    }

    private func writeLineToFile(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }

        let today = formatDate(.now)
        if currentLogDate != today {
            rotateLogFile()
            currentLogDate = today
        }

        ensureFileHandle()
        fileHandle?.write(data)
    }

    private func ensureFileHandle() {
        if fileHandle != nil { return }

        let logsDir = logsDirectory()

        if !FileManager.default.fileExists(atPath: logsDir.path) {
            try? FileManager.default.createDirectory(at: logsDir, withIntermediateDirectories: true)
        }

        let logFile = logsDir.appendingPathComponent("logs.txt")

        if !FileManager.default.fileExists(atPath: logFile.path) {
            FileManager.default.createFile(atPath: logFile.path, contents: nil)
        }

        fileHandle = try? FileHandle(forWritingTo: logFile)
        fileHandle?.seekToEndOfFile()
    }

    private func rotateLogFile() {
        closeFileHandle()

        let logsDir = logsDirectory()
        let activeFile = logsDir.appendingPathComponent("logs.txt")

        guard FileManager.default.fileExists(atPath: activeFile.path) else { return }

        if let attrs = try? FileManager.default.attributesOfItem(atPath: activeFile.path),
           let modDate = attrs[.modificationDate] as? Date
        {
            let fileDate = formatDate(modDate)
            let todayDate = formatDate(.now)

            if fileDate != todayDate {
                let rotatedName = "logs_\(fileDate).txt"
                let rotatedFile = logsDir.appendingPathComponent(rotatedName)

                if FileManager.default.fileExists(atPath: rotatedFile.path) {
                    // Find unique name
                    var counter = 1
                    var candidate = logsDir.appendingPathComponent("logs_\(fileDate)_\(counter).txt")
                    while FileManager.default.fileExists(atPath: candidate.path) {
                        counter += 1
                        candidate = logsDir.appendingPathComponent("logs_\(fileDate)_\(counter).txt")
                    }
                    try? FileManager.default.moveItem(at: activeFile, to: candidate)
                } else {
                    try? FileManager.default.moveItem(at: activeFile, to: rotatedFile)
                }
            }
        }
    }

    private func closeFileHandle() {
        try? fileHandle?.close()
        fileHandle = nil
    }

    // MARK: - Cleanup

    /// Remove log files older than the specified number of days, and enforce a max total size.
    func cleanupLogs(autoDeleteDays: Int, maxSizeMB: Int) {
        let logsDir = logsDirectory()
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: logsDir,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey]
        ) else { return }

        let logFiles = files.filter { $0.pathExtension == "txt" }

        // Delete old files
        if autoDeleteDays > 0 {
            let cutoff = Date.now.addingTimeInterval(-TimeInterval(autoDeleteDays * 86400))
            for file in logFiles {
                if let attrs = try? file.resourceValues(forKeys: [.contentModificationDateKey]),
                   let modDate = attrs.contentModificationDate,
                   modDate < cutoff
                {
                    try? FileManager.default.removeItem(at: file)
                }
            }
        }

        // Enforce max size
        if maxSizeMB > 0 {
            let maxBytes = maxSizeMB * 1024 * 1024
            var totalSize = 0
            var fileInfos: [(url: URL, size: Int, date: Date)] = []

            for file in logFiles {
                if let attrs = try? file.resourceValues(forKeys: [.fileSizeKey, .contentModificationDateKey]),
                   let size = attrs.fileSize,
                   let date = attrs.contentModificationDate
                {
                    totalSize += size
                    fileInfos.append((url: file, size: size, date: date))
                }
            }

            if totalSize > maxBytes {
                // Remove oldest first
                fileInfos.sort { $0.date < $1.date }
                for info in fileInfos {
                    guard totalSize > maxBytes else { break }
                    try? FileManager.default.removeItem(at: info.url)
                    totalSize -= info.size
                }
            }
        }
    }

    // MARK: - Helpers

    private func logsDirectory() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupport.appendingPathComponent("Kelivo/logs")
    }

    private func formatTimestamp(_ date: Date) -> String {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
        let ms = (comps.nanosecond ?? 0) / 1_000_000
        return String(
            format: "%04d-%02d-%02d %02d:%02d:%02d.%03d",
            comps.year ?? 0, comps.month ?? 0, comps.day ?? 0,
            comps.hour ?? 0, comps.minute ?? 0, comps.second ?? 0, ms
        )
    }

    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", comps.year ?? 0, comps.month ?? 0, comps.day ?? 0)
    }

    private func truncate(_ text: String, maxLength: Int) -> String {
        if text.count <= maxLength { return text }
        return String(text.prefix(maxLength)) + "...[truncated]"
    }
}
