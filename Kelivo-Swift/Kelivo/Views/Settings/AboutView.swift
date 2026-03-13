import SwiftUI

struct AboutView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - App Card
                GlassCard(cornerRadius: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.tint)
                            .symbolRenderingMode(.hierarchical)

                        Text("Kelivo")
                            .font(.title.bold())

                        Text(String(localized: "Version \(appVersion) (\(buildNumber))"))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text(String(localized: "A cross-platform LLM chat client"))
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                }

                // MARK: - Links
                GlassCard(cornerRadius: 16) {
                    VStack(spacing: 0) {
                        linkRow(
                            icon: "chevron.left.forwardslash.chevron.right",
                            title: String(localized: "GitHub Repository"),
                            url: "https://github.com/kangalio/kelivo"
                        )
                        Divider().padding(.leading, 40)
                        linkRow(
                            icon: "globe",
                            title: String(localized: "Website"),
                            url: "https://kelivo.app"
                        )
                        Divider().padding(.leading, 40)
                        linkRow(
                            icon: "heart",
                            title: String(localized: "Sponsor"),
                            url: "https://github.com/sponsors/kangalio"
                        )
                    }
                }

                // MARK: - Legal
                GlassCard(cornerRadius: 16) {
                    VStack(spacing: 0) {
                        navigationRow(
                            icon: "doc.text",
                            title: String(localized: "Open Source Licenses")
                        )
                        Divider().padding(.leading, 40)
                        navigationRow(
                            icon: "lock.shield",
                            title: String(localized: "Privacy Policy")
                        )
                    }
                }

                // MARK: - System Info
                GlassCard(cornerRadius: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        infoRow(
                            label: String(localized: "Platform"),
                            value: platformName
                        )
                        Divider()
                        infoRow(
                            label: String(localized: "OS Version"),
                            value: osVersion
                        )
                        Divider()
                        infoRow(
                            label: String(localized: "Device"),
                            value: deviceModel
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "About"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Row Components

    private func linkRow(icon: String, title: String, url: String) -> some View {
        Button {
            if let link = URL(string: url) {
                #if os(iOS)
                UIApplication.shared.open(link)
                #elseif os(macOS)
                NSWorkspace.shared.open(link)
                #endif
            }
        } label: {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundStyle(.tint)
                Text(title)
                Spacer()
                Image(systemName: "arrow.up.forward")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }

    private func navigationRow(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(.tint)
            Text(title)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 8)
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .monospacedDigit()
        }
    }

    // MARK: - System Info Helpers

    private var platformName: String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #else
        return "Unknown"
        #endif
    }

    private var osVersion: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }

    private var deviceModel: String {
        #if os(iOS)
        return UIDevice.current.model
        #elseif os(macOS)
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
        #else
        return "Unknown"
        #endif
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
