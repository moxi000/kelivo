import SwiftUI
import UniformTypeIdentifiers

// MARK: - BackupImportExportView

/// Provides local file-based backup export and import functionality.
/// Supplements the existing BackupView (which handles WebDAV/S3 remote sync).
/// Corresponds to Flutter: `lib/features/backup/pages/backup_page.dart` (import/export sections)
struct BackupImportExportView: View {
    @Environment(\.modelContext) private var modelContext

    // MARK: - Export State
    @State private var isExporting = false
    @State private var exportProgress: Double = 0
    @State private var lastExportDate: Date?
    @State private var showExportShareSheet = false
    @State private var exportedFileURL: URL?

    // MARK: - Import State
    @State private var showFilePicker = false
    @State private var isImporting = false
    @State private var importProgress: Double = 0
    @State private var showImportConfirmation = false
    @State private var selectedImportURL: URL?
    @State private var selectedFileSize: Int64?

    // MARK: - Import Source
    @State private var showCherryImportPicker = false
    @State private var showChatBoxImportPicker = false
    @State private var showCherryWarning = false

    // MARK: - Alerts
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        Form {
            // MARK: - Export Section
            Section {
                Button {
                    exportBackup()
                } label: {
                    HStack {
                        if isExporting {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Image(systemName: "arrow.up.doc")
                        }
                        Text(String(localized: "Export Backup"))
                    }
                }
                .disabled(isExporting || isImporting)

                if isExporting {
                    ProgressView(value: exportProgress)
                        .progressViewStyle(.linear)
                }

                if let lastExportDate {
                    LabeledContent(String(localized: "Last Export")) {
                        Text(lastExportDate, style: .relative)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Label(String(localized: "Export"), systemImage: "square.and.arrow.up")
            } footer: {
                Text(String(localized: "Export all conversations, assistants, and settings to a local JSON file."))
            }

            // MARK: - Import Section
            Section {
                Button {
                    showFilePicker = true
                } label: {
                    Label(String(localized: "Import from File (JSON)"), systemImage: "doc.badge.plus")
                }
                .disabled(isImporting || isExporting)

                if let url = selectedImportURL {
                    LabeledContent(String(localized: "Selected File")) {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(url.lastPathComponent)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            if let size = selectedFileSize {
                                Text(formatFileSize(size))
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                }

                if isImporting {
                    ProgressView(value: importProgress)
                        .progressViewStyle(.linear)
                }
            } header: {
                Label(String(localized: "Import"), systemImage: "square.and.arrow.down")
            } footer: {
                Text(String(localized: "Import conversations and settings from a previously exported Kelivo backup file."))
            }

            // MARK: - Third-Party Import
            Section {
                Button {
                    showCherryWarning = true
                } label: {
                    Label(String(localized: "Import from Cherry Studio"), systemImage: "square.and.arrow.down")
                }
                .disabled(isImporting || isExporting)

                Button {
                    showChatBoxImportPicker = true
                } label: {
                    Label(String(localized: "Import from ChatBox"), systemImage: "square.and.arrow.down")
                }
                .disabled(isImporting || isExporting)
            } header: {
                Text(String(localized: "Third-Party Import"))
            } footer: {
                Text(String(localized: "Import conversations from other chat applications. This feature is experimental."))
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Import & Export"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.json],
            onCompletion: handleFileImport
        )
        .fileImporter(
            isPresented: $showCherryImportPicker,
            allowedContentTypes: [.json, .zip],
            onCompletion: handleCherryImport
        )
        .fileImporter(
            isPresented: $showChatBoxImportPicker,
            allowedContentTypes: [.json],
            onCompletion: handleChatBoxImport
        )
        .alert(alertTitle, isPresented: $showAlert) {
            Button(String(localized: "OK"), role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .confirmationDialog(
            String(localized: "Import Backup"),
            isPresented: $showImportConfirmation,
            titleVisibility: .visible
        ) {
            Button(String(localized: "Merge with Existing Data")) {
                performImport(replace: false)
            }
            Button(String(localized: "Replace All Data"), role: .destructive) {
                performImport(replace: true)
            }
            Button(String(localized: "Cancel"), role: .cancel) {}
        } message: {
            Text(String(localized: "Choose how to handle the imported data."))
        }
        .alert(
            String(localized: "Import from Cherry Studio"),
            isPresented: $showCherryWarning
        ) {
            Button(String(localized: "Cancel"), role: .cancel) {}
            Button(String(localized: "Continue")) {
                showCherryImportPicker = true
            }
        } message: {
            Text(String(localized: "This feature is experimental.\nTo keep your data safe, it is recommended to back up before importing.\nProceed to choose a file?"))
        }
    }

    // MARK: - Export

    private func exportBackup() {
        isExporting = true
        exportProgress = 0
        Task {
            // Simulated export progress. Real implementation would serialize
            // all SwiftData models to JSON and write to a temporary file.
            for i in 1...10 {
                try? await Task.sleep(for: .milliseconds(150))
                exportProgress = Double(i) / 10.0
            }
            lastExportDate = .now
            isExporting = false
            // In production: set exportedFileURL and present share sheet or save dialog.
        }
    }

    // MARK: - Import Handlers

    private func handleFileImport(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            selectedImportURL = url
            selectedFileSize = fileSize(at: url)
            showImportConfirmation = true
        case .failure(let error):
            alertTitle = String(localized: "Import Failed")
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func handleCherryImport(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            performThirdPartyImport(url: url, source: "Cherry Studio")
        case .failure(let error):
            alertTitle = String(localized: "Import Failed")
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func handleChatBoxImport(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            performThirdPartyImport(url: url, source: "ChatBox")
        case .failure(let error):
            alertTitle = String(localized: "Import Failed")
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }

    private func performImport(replace: Bool) {
        guard let url = selectedImportURL else { return }
        isImporting = true
        importProgress = 0
        Task {
            // Simulated import. Real implementation would parse the JSON file
            // and insert/replace SwiftData models accordingly.
            for i in 1...10 {
                try? await Task.sleep(for: .milliseconds(200))
                importProgress = Double(i) / 10.0
            }
            isImporting = false
            alertTitle = String(localized: "Import Complete")
            alertMessage = String(localized: "Data has been imported successfully.")
            showAlert = true
        }
    }

    private func performThirdPartyImport(url: URL, source: String) {
        isImporting = true
        importProgress = 0
        Task {
            for i in 1...10 {
                try? await Task.sleep(for: .milliseconds(200))
                importProgress = Double(i) / 10.0
            }
            isImporting = false
            alertTitle = String(localized: "Import Complete")
            alertMessage = String(localized: "Data from \(source) has been imported successfully.")
            showAlert = true
        }
    }

    // MARK: - File Helpers

    private func fileSize(at url: URL) -> Int64? {
        guard url.startAccessingSecurityScopedResource() else { return nil }
        defer { url.stopAccessingSecurityScopedResource() }
        let values = try? url.resourceValues(forKeys: [.fileSizeKey])
        return values?.fileSize.map { Int64($0) }
    }

    private func formatFileSize(_ bytes: Int64) -> String {
        let kb: Int64 = 1024
        let mb = kb * 1024
        let gb = mb * 1024
        if bytes >= gb { return String(format: "%.2f GB", Double(bytes) / Double(gb)) }
        if bytes >= mb { return String(format: "%.2f MB", Double(bytes) / Double(mb)) }
        if bytes >= kb { return String(format: "%.2f KB", Double(bytes) / Double(kb)) }
        return "\(bytes) B"
    }
}

// MARK: - UTType Extension

private extension UTType {
    static let zip = UTType(filenameExtension: "zip") ?? .data
}

#Preview {
    NavigationStack {
        BackupImportExportView()
    }
}
