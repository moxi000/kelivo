import SwiftUI

// MARK: - MacToolbar

/// macOS-specific toolbar items providing new chat, sidebar toggle,
/// and additional chat controls with Liquid Glass button styling.
struct MacToolbar: ToolbarContent {
    let onNewChat: () -> Void
    let onToggleSidebar: () -> Void

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                onNewChat()
            } label: {
                Image(systemName: "square.and.pencil")
            }
            .toolbarGlassButton()
            .help(String(localized: "newChat"))

            Button {
                onToggleSidebar()
            } label: {
                Image(systemName: "sidebar.left")
            }
            .toolbarGlassButton()
            .help(String(localized: "toggleSidebar"))
        }
    }
}

// MARK: - Glass Modifier

private extension View {
    @ViewBuilder
    func toolbarGlassButton() -> some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.plain)
        }
    }
}
