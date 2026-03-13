import SwiftUI
import SwiftData

struct ProvidersListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ProviderConfig.sortOrder) private var providers: [ProviderConfig]
    @State private var showAddProvider = false

    var body: some View {
        List {
            ForEach(providers) { provider in
                NavigationLink {
                    ProviderDetailView(provider: provider)
                } label: {
                    providerRow(provider)
                }
            }
            .onDelete(perform: deleteProviders)
        }
        .navigationTitle(String(localized: "Providers"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddProvider = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddProvider) {
            AddProviderView()
        }
        .overlay {
            if providers.isEmpty {
                ContentUnavailableView {
                    Label(String(localized: "No Providers"), systemImage: "server.rack")
                } description: {
                    Text(String(localized: "Add an LLM provider to get started."))
                } actions: {
                    Button {
                        showAddProvider = true
                    } label: {
                        Text(String(localized: "Add Provider"))
                    }
                    .applyGlassProminent()
                }
            }
        }
    }

    // MARK: - Row

    private func providerRow(_ provider: ProviderConfig) -> some View {
        HStack(spacing: 12) {
            Image(systemName: iconForApiType(provider.apiType))
                .font(.title3)
                .foregroundStyle(colorForApiType(provider.apiType))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(provider.name)
                    .font(.body)
                Text(provider.baseUrl)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Circle()
                .fill(provider.isEnabled ? .green : .gray)
                .frame(width: 8, height: 8)
        }
        .padding(.vertical, 2)
    }

    // MARK: - Actions

    private func deleteProviders(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(providers[index])
        }
    }

    // MARK: - Helpers

    private func iconForApiType(_ type: ApiType) -> String {
        switch type {
        case .openai: return "brain.head.profile"
        case .claude: return "sparkle"
        case .gemini: return "diamond"
        case .vertex: return "cloud"
        }
    }

    private func colorForApiType(_ type: ApiType) -> Color {
        switch type {
        case .openai: return .green
        case .claude: return .orange
        case .gemini: return .blue
        case .vertex: return .purple
        }
    }
}

// MARK: - Glass Button Modifier

private extension View {
    @ViewBuilder
    func applyGlassProminent() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigationStack {
        ProvidersListView()
    }
}
