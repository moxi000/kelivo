import SwiftUI

struct SponsorView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - App Header

                GlassCard(cornerRadius: 20) {
                    VStack(spacing: 12) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.tint)
                            .symbolRenderingMode(.hierarchical)

                        Text("Kelivo")
                            .font(.title.bold())

                        Text(String(localized: "Version \(appVersion)"))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }

                // MARK: - Sponsor Message

                GlassCard(cornerRadius: 16) {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundStyle(.pink)

                        Text(String(localized: "Support Kelivo"))
                            .font(.headline)

                        Text(
                            String(
                                localized:
                                    "Kelivo is an open-source project. Your support helps keep it maintained and improving."
                            )
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }

                // MARK: - Sponsor Links

                GlassCard(cornerRadius: 16) {
                    VStack(spacing: 0) {
                        sponsorLink(
                            icon: "heart.circle",
                            title: String(localized: "GitHub Sponsors"),
                            subtitle: String(localized: "Monthly or one-time sponsorship"),
                            url: "https://github.com/sponsors/kangalio"
                        )

                        Divider().padding(.leading, 40)

                        sponsorLink(
                            icon: "cup.and.saucer",
                            title: String(localized: "Buy Me a Coffee"),
                            subtitle: String(localized: "One-time donation"),
                            url: "https://buymeacoffee.com/kelivo"
                        )
                    }
                }

                // MARK: - Acknowledgments

                GlassCard(cornerRadius: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(String(localized: "Acknowledgments"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(
                            String(
                                localized:
                                    "Thanks to all contributors, sponsors, and the open-source community for making this project possible."
                            )
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        Divider()

                        acknowledgmentRow(
                            name: "Swift & SwiftUI",
                            description: String(localized: "Apple's modern UI framework")
                        )
                        acknowledgmentRow(
                            name: "Flutter",
                            description: String(localized: "Cross-platform UI toolkit")
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle(String(localized: "Sponsor"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Components

    private func sponsorLink(
        icon: String,
        title: String,
        subtitle: String,
        url: String
    ) -> some View {
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
                    .font(.title3)
                    .frame(width: 28)
                    .foregroundStyle(.pink)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

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

    private func acknowledgmentRow(name: String, description: String) -> some View {
        HStack {
            Text(name)
                .font(.subheadline.weight(.medium))
            Spacer()
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        SponsorView()
    }
}
