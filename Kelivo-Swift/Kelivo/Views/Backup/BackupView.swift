import SwiftUI

@available(iOS 26.0, macOS 26.0, *)
struct BackupView: View {
    @Environment(BackupViewModel.self) private var backupVM

    var body: some View {
        @Bindable var vm = backupVM
        Form {
            // MARK: - WebDAV Section
            Section {
                TextField(String(localized: "webdavUrl"), text: $vm.webDavUrl)
                    .textContentType(.URL)
                TextField(String(localized: "username"), text: $vm.webDavUsername)
                SecureField(String(localized: "password"), text: .constant(""))
                TextField(String(localized: "remotePath"), text: $vm.webDavPath)
                Toggle(String(localized: "autoBackup"), isOn: $vm.webDavAutoBackup)
                if vm.webDavAutoBackup {
                    Stepper(String(localized: "intervalMinutes \(vm.webDavAutoInterval)"),
                            value: $vm.webDavAutoInterval, in: 5...1440, step: 5)
                }
                if let last = vm.webDavLastBackup {
                    HStack {
                        Text(String(localized: "lastBackup"))
                        Spacer()
                        Text(last, style: .relative)
                            .foregroundStyle(.secondary)
                    }
                }
                HStack {
                    Button(String(localized: "backupNow")) {
                        Task { try? await backupVM.backupToWebDAV() }
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(backupVM.isBackingUp)

                    Button(String(localized: "restore")) {
                        Task { try? await backupVM.restoreFromWebDAV() }
                    }
                    .buttonStyle(.glass)
                    .disabled(backupVM.isRestoring)
                }
            } header: {
                Label("WebDAV", systemImage: "externaldrive.connected.to.line.below")
            }

            // MARK: - S3 Section
            Section {
                TextField(String(localized: "s3Endpoint"), text: $vm.s3Endpoint)
                TextField(String(localized: "s3Bucket"), text: $vm.s3Bucket)
                TextField(String(localized: "s3Region"), text: $vm.s3Region)
                SecureField(String(localized: "accessKey"), text: $vm.s3AccessKey)
                Toggle(String(localized: "autoBackup"), isOn: $vm.s3AutoBackup)
                if let last = vm.s3LastBackup {
                    HStack {
                        Text(String(localized: "lastBackup"))
                        Spacer()
                        Text(last, style: .relative)
                            .foregroundStyle(.secondary)
                    }
                }
                HStack {
                    Button(String(localized: "backupNow")) {
                        Task { try? await backupVM.backupToS3() }
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(backupVM.isBackingUp)

                    Button(String(localized: "restore")) {
                        Task { try? await backupVM.restoreFromS3() }
                    }
                    .buttonStyle(.glass)
                    .disabled(backupVM.isRestoring)
                }
            } header: {
                Label("S3", systemImage: "cloud")
            }

            // MARK: - Import/Export
            Section {
                Button(String(localized: "exportToFile")) {
                    Task { _ = try? await backupVM.exportToFile() }
                }
                .buttonStyle(.glass)

                Button(String(localized: "importFromFile")) {
                    // File picker
                }
                .buttonStyle(.glass)

                Button(String(localized: "importFromChatBox")) {
                    // ChatBox import
                }
                Button(String(localized: "importFromCherryStudio")) {
                    // Cherry Studio import
                }
            } header: {
                Label(String(localized: "importExport"), systemImage: "arrow.up.arrow.down")
            }

            // MARK: - Progress
            if backupVM.isBackingUp || backupVM.isRestoring {
                Section {
                    ProgressView(value: backupVM.backupProgress)
                    Text(backupVM.isBackingUp
                         ? String(localized: "backingUp")
                         : String(localized: "restoring"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if let error = backupVM.errorMessage {
                Section {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
        }
        .navigationTitle(String(localized: "backupSync"))
    }
}
