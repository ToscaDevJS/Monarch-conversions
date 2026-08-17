import SwiftUI
import SwiftData

@main
struct Monarch_conversionsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ConversionRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("Failed to initialize persistent ModelContainer: \(error). Destroying old store files and retrying...")
            removeDefaultStoreFiles()
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                print("Failed persistent retry: \(error). Falling back to in-memory container.")
                do {
                    let inMemoryConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                    return try ModelContainer(for: schema, configurations: [inMemoryConfig])
                } catch {
                    fatalError("Could not create ModelContainer: \(error)")
                }
            }
        }
    }()

    private static func removeDefaultStoreFiles() {
        let fileManager = FileManager.default
        guard let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return }
        let storeFiles = ["default.store", "default.store-shm", "default.store-wal"]
        for fileName in storeFiles {
            let fileURL = appSupport.appendingPathComponent(fileName)
            try? fileManager.removeItem(at: fileURL)
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
        .commands {
            SidebarCommands()
            CommandGroup(replacing: .appInfo) {
                Button("About Monarch") {
                    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.18.0"
                    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "20"
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
