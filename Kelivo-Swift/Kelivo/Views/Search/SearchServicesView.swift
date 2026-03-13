import SwiftUI

@available(iOS 26.0, macOS 26.0, *)
struct SearchServicesView: View {
    @Environment(SearchViewModel.self) private var searchVM
    @State private var editingProvider: SearchViewModel.SearchProviderConfig?

    var body: some View {
        @Bindable var vm = searchVM
        List {
            Section {
                ForEach(vm.searchProviders) { provider in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(provider.type.rawValue.capitalized)
                                .font(.headline)
                            if let url = provider.baseUrl, !url.isEmpty {
                                Text(url)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        if provider.id == vm.activeProviderId {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }

                        Toggle("", isOn: Binding(
                            get: { provider.isEnabled },
                            set: { _ in
                                // Toggle enable state
                            }
                        ))
                        .labelsHidden()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        searchVM.setActiveProvider(provider.id)
                    }
                }
            } header: {
                Text(String(localized: "searchProviders"))
            }

            Section {
                Text(String(localized: "searchProvidersDescription"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(String(localized: "searchServices"))
    }
}
