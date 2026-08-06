import SwiftUI
import SwiftData

struct RootView: View {
    @State private var router = AppRouter()
    @State private var userSettings = UserSettings()
    
    var body: some View {
        Group {
            switch router.activeTab {
            case .settings:
                SettingsScene(userSettings: userSettings) { newTab in
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
        .preferredColorScheme(userSettings.preferredColorScheme)
        .environment(\.locale, userSettings.language.locale)
    }
}

#Preview {
    RootView()
        .modelContainer(for: ConversionRecord.self, inMemory: true)
}
