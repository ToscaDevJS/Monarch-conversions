import SwiftUI

@Observable
final class AppRouter {
    var activeTab: AppTab = .studio
    
    func navigateTo(_ tab: AppTab) {
        activeTab = tab
    }
}
