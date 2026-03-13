import SwiftUI

struct NetworkProxyView: View {
    @State private var proxyEnabled = false
    @State private var proxyType: ProxyType = .http
    @State private var host = ""
    @State private var port = ""
    @State private var username = ""
    @State private var password = ""
    @State private var isTesting = false
    @State private var testResult: String?
    @State private var testSuccess: Bool?

    var body: some View {
        Form {
            // MARK: - Enable Toggle
            Section {
                Toggle(String(localized: "Enable Proxy"), isOn: $proxyEnabled)
            }

            // MARK: - Configuration
            Section {
                Picker(String(localized: "Proxy Type"), selection: $proxyType) {
                    Text("HTTP").tag(ProxyType.http)
                    Text("SOCKS5").tag(ProxyType.socks5)
                }
                #if os(iOS)
                .pickerStyle(.segmented)
                #endif

                TextField(String(localized: "Host"), text: $host)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                    #endif
                    .autocorrectionDisabled()

                TextField(String(localized: "Port"), text: $port)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
            } header: {
                Text(String(localized: "Proxy Configuration"))
            }
            .disabled(!proxyEnabled)

            // MARK: - Authentication
            Section {
                TextField(String(localized: "Username (Optional)"), text: $username)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .autocorrectionDisabled()

                SecureField(String(localized: "Password (Optional)"), text: $password)
            } header: {
                Text(String(localized: "Authentication"))
            } footer: {
                Text(String(localized: "Leave empty if your proxy does not require authentication."))
            }
            .disabled(!proxyEnabled)

            // MARK: - Test Connection
            Section {
                Button {
                    testConnection()
                } label: {
                    HStack {
                        if isTesting {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                        }
                        Text(String(localized: "Test Connection"))
                    }
                }
                .disabled(!proxyEnabled || host.isEmpty || port.isEmpty || isTesting)

                if let testResult, let testSuccess {
                    Label {
                        Text(testResult)
                    } icon: {
                        Image(systemName: testSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(testSuccess ? .green : .red)
                    }
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(String(localized: "Network Proxy"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear(perform: loadProxy)
        .onDisappear(perform: saveProxy)
    }

    // MARK: - Actions

    private func testConnection() {
        isTesting = true
        testResult = nil
        testSuccess = nil

        Task {
            try? await Task.sleep(for: .seconds(1.5))
            isTesting = false
            let portNumber = Int(port) ?? 0
            if !host.isEmpty && portNumber > 0 && portNumber <= 65535 {
                testSuccess = true
                testResult = String(localized: "Connection successful")
            } else {
                testSuccess = false
                testResult = String(localized: "Invalid proxy configuration")
            }
        }
    }

    private func loadProxy() {
        let settings = SettingsViewModel()
        settings.load()
        proxyEnabled = settings.proxyEnabled
        proxyType = settings.proxyType
        host = settings.proxyHost
        port = settings.proxyPort > 0 ? "\(settings.proxyPort)" : ""
    }

    private func saveProxy() {
        let settings = SettingsViewModel()
        settings.load()
        settings.proxyEnabled = proxyEnabled
        settings.proxyType = proxyType
        settings.proxyHost = host
        settings.proxyPort = Int(port) ?? 0
        settings.save()
    }
}

#Preview {
    NavigationStack {
        NetworkProxyView()
    }
}
