import SwiftUI

// MARK: - Log Entry Model

struct LogEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let level: LogLevel
    let message: String
    let source: String?

    enum LogLevel: String, CaseIterable {
        case debug
        case info
        case warning
        case error

        var color: Color {
            switch self {
            case .debug: return .secondary
            case .info: return .blue
            case .warning: return .orange
            case .error: return .red
            }
        }

        var icon: String {
            switch self {
            case .debug: return "ant"
            case .info: return "info.circle"
            case .warning: return "exclamationmark.triangle"
            case .error: return "xmark.octagon"
            }
        }
    }
}

// MARK: - LogViewerView

struct LogViewerView: View {
    @State private var logEntries: [LogEntry] = []
    @State private var searchText: String = ""
    @State private var selectedLevel: LogEntry.LogLevel? = nil
    @State private var autoScroll: Bool = true

    private var filteredEntries: [LogEntry] {
        logEntries.filter { entry in
            let matchesLevel = selectedLevel == nil || entry.level == selectedLevel
            let matchesSearch = searchText.isEmpty
                || entry.message.localizedCaseInsensitiveContains(searchText)
                || (entry.source?.localizedCaseInsensitiveContains(searchText) ?? false)
            return matchesLevel && matchesSearch
        }
    }

    private static let timestampFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"
        return f
    }()

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Filter Bar

            filterBar
                .padding(.horizontal)
                .padding(.vertical, 8)

            Divider()

            // MARK: - Log List

            if filteredEntries.isEmpty {
                ContentUnavailableView(
                    String(localized: "No Logs"),
                    systemImage: "doc.text.magnifyingglass",
                    description: Text(String(localized: "No log entries match the current filter."))
                )
            } else {
                ScrollViewReader { proxy in
                    List(filteredEntries) { entry in
                        logRow(entry)
                            .id(entry.id)
                            .contextMenu {
                                Button {
                                    copyToClipboard(entry)
                                } label: {
                                    Label(
                                        String(localized: "Copy"),
                                        systemImage: "doc.on.doc"
                                    )
                                }
                            }
                    }
                    .listStyle(.plain)
                    .onChange(of: filteredEntries.count) {
                        if autoScroll, let last = filteredEntries.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
        .searchable(
            text: $searchText,
            prompt: Text(String(localized: "Search Logs"))
        )
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Toggle(isOn: $autoScroll) {
                    Label(
                        String(localized: "Auto-Scroll"),
                        systemImage: autoScroll
                            ? "arrow.down.to.line.circle.fill"
                            : "arrow.down.to.line.circle"
                    )
                }
                .toggleStyle(.button)

                Button(role: .destructive) {
                    logEntries.removeAll()
                } label: {
                    Label(
                        String(localized: "Clear Logs"),
                        systemImage: "trash"
                    )
                }
                .disabled(logEntries.isEmpty)
            }
        }
        .navigationTitle(String(localized: "Log Viewer"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear(perform: loadLogs)
    }

    // MARK: - Filter Bar

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(
                    title: String(localized: "All"),
                    isSelected: selectedLevel == nil
                ) {
                    selectedLevel = nil
                }

                ForEach(LogEntry.LogLevel.allCases, id: \.self) { level in
                    FilterChip(
                        title: level.rawValue.capitalized,
                        isSelected: selectedLevel == level,
                        tint: level.color
                    ) {
                        selectedLevel = level
                    }
                }
            }
        }
    }

    // MARK: - Log Row

    private func logRow(_ entry: LogEntry) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: entry.level.icon)
                .foregroundStyle(entry.level.color)
                .font(.caption)
                .frame(width: 16)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(Self.timestampFormatter.string(from: entry.timestamp))
                        .font(.caption2.monospaced())
                        .foregroundStyle(.tertiary)

                    if let source = entry.source {
                        Text(source)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                Text(entry.message)
                    .font(.caption.monospaced())
                    .foregroundStyle(entry.level == .error ? entry.level.color : .primary)
                    .textSelection(.enabled)
            }
        }
        .padding(.vertical, 2)
    }

    // MARK: - Actions

    private func copyToClipboard(_ entry: LogEntry) {
        let text = "[\(entry.level.rawValue.uppercased())] "
            + "\(Self.timestampFormatter.string(from: entry.timestamp)) "
            + (entry.source.map { "[\($0)] " } ?? "")
            + entry.message

        #if os(iOS)
        UIPasteboard.general.string = text
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif
    }

    private func loadLogs() {
        // Placeholder: load from a logging framework or file
        // In production, wire this to the app's actual logging backend.
        if logEntries.isEmpty {
            logEntries = [
                LogEntry(
                    timestamp: Date(),
                    level: .info,
                    message: String(localized: "Log viewer ready."),
                    source: "System"
                ),
            ]
        }
    }
}

// MARK: - Filter Chip

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var tint: Color = .accentColor
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? tint.opacity(0.15) : Color.clear)
                .foregroundStyle(isSelected ? tint : .secondary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? tint.opacity(0.4) : Color.secondary.opacity(0.3))
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        LogViewerView()
    }
}
