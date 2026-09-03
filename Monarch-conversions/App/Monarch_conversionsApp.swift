import SwiftUI
import SwiftData

@main
struct Monarch_conversionsApp: App {
    var sharedModelContainer: ModelContainer = {
        ModelContainerFactory.createContainer()
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(minWidth: MonarchUI.Layout.minWindowWidth, minHeight: MonarchUI.Layout.minWindowHeight)
        }
        .windowResizability(.contentMinSize)
        .modelContainer(sharedModelContainer)
        .commands {
            SidebarCommands()
            CommandGroup(replacing: .appInfo) {
                Button("About Monarch") {
                    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.28.0"
                    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "28"
                    NSApplication.shared.orderFrontStandardAboutPanel(
                        options: [
                            .applicationName: "Monarch",
                            .applicationVersion: version,
                            .version: build,
                            NSApplication.AboutPanelOptionKey(rawValue: "Copyright"): "Copyright © 2026 ToscaDev. All rights reserved."
                        ]
                    )
                }
            }
        }
    }
}
