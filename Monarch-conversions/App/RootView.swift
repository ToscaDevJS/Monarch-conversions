import SwiftUI
import SwiftData

struct RootView: View {
    @State private var router = AppRouter()
    @State private var userSettings = UserSettings()
    
    var body: some View {
        ZStack {
            DashboardScene { newTab in
                router.navigateTo(newTab)
            }
            .opacity(router.activeTab == .studio ? 1 : 0)
            .allowsHitTesting(router.activeTab == .studio)

            ConvertScene { newTab in
                router.navigateTo(newTab)
            }
            .opacity(router.activeTab == .convert ? 1 : 0)
            .allowsHitTesting(router.activeTab == .convert)

            SettingsScene(userSettings: userSettings) { newTab in
                router.navigateTo(newTab)
            }
            .opacity(router.activeTab == .settings ? 1 : 0)
            .allowsHitTesting(router.activeTab == .settings)
        }
        // The minimum size is declared once, at the scene in Monarch_conversionsApp,
        // because that is what .windowResizability(.contentMinSize) reads.
        .preferredColorScheme(userSettings.preferredColorScheme)
        .environment(\.locale, userSettings.language.locale)
        .background {
            Group {
                Button("Studio Tab") {
                    router.navigateTo(.studio)
                }
                .keyboardShortcut("1", modifiers: .command)

                Button("Convert Tab") {
                    router.navigateTo(.convert)
                }
                .keyboardShortcut("2", modifiers: .command)

                Button("Settings Tab") {
                    router.navigateTo(.settings)
                }
                .keyboardShortcut("3", modifiers: .command)
            }
            .opacity(0)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: ConversionRecord.self, inMemory: true)
}
