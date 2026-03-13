import SwiftUI

@Observable
final class AppState: Sendable {
    var selectedConversationID: String?
    var isShowingSettings: Bool = false
    var sidebarVisibility: NavigationSplitViewVisibility = .automatic

    init(
        selectedConversationID: String? = nil,
        isShowingSettings: Bool = false,
        sidebarVisibility: NavigationSplitViewVisibility = .automatic
    ) {
        self.selectedConversationID = selectedConversationID
        self.isShowingSettings = isShowingSettings
        self.sidebarVisibility = sidebarVisibility
    }
}
