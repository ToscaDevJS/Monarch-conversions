import SwiftUI

@Observable
final class AppRouter {
    var activeTab: AppTab

    init(activeTab: AppTab = AppRouter.initialTab()) {
        self.activeTab = activeTab
    }

    func navigateTo(_ tab: AppTab) {
        activeTab = tab
    }

    private static func initialTab() -> AppTab {
        if ProcessInfo.processInfo.arguments.contains("-ui-testing-convert") {
            return .convert
        }
        return .studio
    }
}
