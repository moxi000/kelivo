import SwiftUI
import SwiftData

struct BackupView: View {
    // MARK: - WebDAV State
    @State private var webdavUrl = ""
    @State private var webdavUsername = ""
    @State private var webdavPassword = ""
    @State private var webdavPath = "kelivo_backups"
    @State private var webdavAutoBackup = false

    // MARK: - S3 State
    @State private var s3Endpoint = ""
    @State private var s3Bucket = ""
    @State private var s3Region = "us-east-1"
    @State private var s3AccessKey = ""
    @State private var s3SecretKey = ""

    // MARK: - Progress
    @State private var isBackingUp = false
    @State private var isRestoring = false
    @State private var lastBackupDate: Date?
    @State private var showImportPicker = false
    @State private var backupProgress: Double = 0

    var body: some View {
        Form {
            // MARK: - WebDAV
            Section {
                TextField(String(localized: "Server URL"), text: $webdavUrl)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    #endif

                TextField(String(localized: "Username"), text: $webdavUsername)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif

                SecureField(String(localized: "Password"), text: $webdavPassword)

                TextField(String(localized: "Remote Path"), text: $webdavPath)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif

                Toggle(String(localized: "Auto Backup"), isOn: $webdavAutoBackup)
            } header: {
                Label(String(localized: "WebDAV"), systemImage: "externaldrive.connected.to.line.below")
            }

            // MARK: - S3
            Section {
                TextField(String(localized: "Endpoint"), text: $s3Endpoint)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    #endif

                TextField(String(localized: "Bucket"), text: $s3Bucket)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif

                TextField(String(localized: "Region"), text: $s3Region)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif

                SecureField(String(localized: "Access Key"), text: $s3AccessKey)
                SecureField(String(localized: "Secret Key"), text: $s3SecretKey)
            } header: {
                Label(String(localized: "S3 Compatible Storage"), systemImage: "cloud")
            }

            // MARK: - Manual Backup/Restore
            Section {
                Button {
                    performBackup()
                } label: {
                    HStack {
                        if isBackingUp {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Image(systemName: "arrow.up.doc")
                        }
                        Text(String(localized: "Backup Now"))
                    }
                }
                .disabled(isBackingUp || isRestoring)

                Button {
                    performRestore()
                } label: {
                    HStack {
                        if isRestoring {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Image(systemName: "arrow.down.doc")
                        }
                        Text(String(localized: "Restore from Backup"))
                    }
                }
                .disabled(isBackingUp || isRestoring)

                if isBackingUp || isRestoring {
                    ProgressView(value: backupProgress)
                        .progressViewStyle(.linear)
                }

                if let lastBackupDate {
                    LabeledContent(String(localized: "Last Backup")) {
                        Text(lastBackupDate, style: .relative)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text(String(localized: "Manual"))
            }

            // MARK: - Import
            Section {
                Button {
                    showImportPicker = true
                } label: {
                    Label(String(localized: "Import from File (JSON)"), systemImage: "doc.badge.plus")
                }

                Button {
                    // Placeholder
                } label: {
                    Label(String(localized: "Import from ChatBox"), systemImage: "square.and.arrow.down")
                }

                Button {
                    // Placeholder
                } label: {
                    Label(String(localized: "Import from Cherry Studio"), systemImage: "square.and.arrow.down")
                }
            } header: {
                Text(String(localized: "Import"))
            } footer: {
                Text(String(localized: "Import conversations and settings from other applications."))
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Backup & Sync"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Actions

    private func performBackup() {
        isBackingUp = true
        backupProgress = 0
        Task {
            for i in 1...10 {
                try? await Task.sleep(for: .milliseconds(200))
                backupProgress = Double(i) / 10.0
            }
            lastBackupDate = .now
            isBackingUp = false
        }
    }

    private func performRestore() {
        isRestoring = true
        backupProgress = 0
        Task {
            for i in 1...10 {
                try? await Task.sleep(for: .milliseconds(300))
                backupProgress = Double(i) / 10.0
            }
            isRestoring = false
        }
    }
}

#Preview {
    NavigationStack {
        BackupView()
    }
}
