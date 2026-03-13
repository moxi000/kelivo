import SwiftUI

struct StorageSpaceView: View {
    @State private var totalSize: String = "--"
    @State private var conversationsSize: String = "--"
    @State private var messagesSize: String = "--"
    @State private var imagesSize: String = "--"
    @State private var backupsSize: String = "--"
    @State private var isCalculating = false
    @State private var showClearCacheAlert = false
    @State private var showClearAllAlert = false

    var body: some View {
        Form {
            // MARK: - Overview
            Section {
                HStack {
                    Label(String(localized: "Total Storage Used"), systemImage: "externaldrive")
                    Spacer()
                    if isCalculating {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Text(totalSize)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    }
                }
            }

            // MARK: - Breakdown
            Section {
                storageRow(
                    icon: "bubble.left.and.bubble.right",
                    color: .blue,
                    title: String(localized: "Conversations"),
                    size: conversationsSize
                )
                storageRow(
                    icon: "text.bubble",
                    color: .green,
                    title: String(localized: "Messages"),
                    size: messagesSize
                )
                storageRow(
                    icon: "photo",
                    color: .orange,
                    title: String(localized: "Images & Files"),
                    size: imagesSize
                )
                storageRow(
                    icon: "archivebox",
                    color: .purple,
                    title: String(localized: "Backups"),
                    size: backupsSize
                )
            } header: {
                Text(String(localized: "Breakdown"))
            }

            // MARK: - Actions
            Section {
                Button(role: .destructive) {
                    showClearCacheAlert = true
                } label: {
                    Label(String(localized: "Clear Cache"), systemImage: "trash")
                }
                .alert(String(localized: "Clear Cache"), isPresented: $showClearCacheAlert) {
                    Button(String(localized: "Cancel"), role: .cancel) {}
                    Button(String(localized: "Clear"), role: .destructive) {
                        clearCache()
                    }
                } message: {
                    Text(String(localized: "This will remove cached images and temporary files. Your conversations and settings will not be affected."))
                }

                Button(role: .destructive) {
                    showClearAllAlert = true
                } label: {
                    Label(String(localized: "Clear All Data"), systemImage: "trash.fill")
                }
                .alert(String(localized: "Clear All Data"), isPresented: $showClearAllAlert) {
                    Button(String(localized: "Cancel"), role: .cancel) {}
                    Button(String(localized: "Delete Everything"), role: .destructive) {
                        clearAllData()
                    }
                } message: {
                    Text(String(localized: "This will permanently delete all conversations, messages, settings, and local data. This action cannot be undone."))
                }
            } header: {
                Text(String(localized: "Manage Storage"))
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Storage Space"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            calculateStorage()
        }
    }

    // MARK: - Components

    private func storageRow(icon: String, color: Color, title: String, size: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)
            Text(title)
            Spacer()
            Text(size)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }

    // MARK: - Actions

    private func calculateStorage() {
        isCalculating = true
        Task {
            try? await Task.sleep(for: .milliseconds(500))
            // Placeholder — real implementation would query SwiftData + file system
            conversationsSize = "2.1 MB"
            messagesSize = "8.4 MB"
            imagesSize = "15.3 MB"
            backupsSize = "4.7 MB"
            totalSize = "30.5 MB"
            isCalculating = false
        }
    }

    private func clearCache() {
        Task {
            // Placeholder — real implementation would clear URLCache and temp files
            imagesSize = "0 B"
            calculateStorage()
        }
    }

    private func clearAllData() {
        Task {
            // Placeholder — real implementation would purge SwiftData container + files
            conversationsSize = "0 B"
            messagesSize = "0 B"
            imagesSize = "0 B"
            backupsSize = "0 B"
            totalSize = "0 B"
        }
    }
}

#Preview {
    NavigationStack {
        StorageSpaceView()
    }
}
