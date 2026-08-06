import SwiftUI
import SwiftData

struct RootView: View {
    @State private var router = AppRouter()
    
    var body: some View {
        Group {
            switch router.activeTab {
            case .settings:
                SettingsScene { newTab in
                    router.navigateTo(newTab)
                }
            case .convert:
                ConvertScene { newTab in
                    router.navigateTo(newTab)
                }
            default:
                DashboardScene { newTab in
                    router.navigateTo(newTab)
                }
            }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: ConversionRecord.self, inMemory: true)
}
