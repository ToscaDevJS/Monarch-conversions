import Foundation
import SwiftData

public struct ModelContainerFactory {
    public static func createContainer(
        schema: Schema? = nil,
        storeURL: URL? = nil,
        isStoredInMemoryOnly: Bool = false
    ) -> ModelContainer {
        let resolvedSchema = schema ?? Schema([ConversionRecord.self])
        if isStoredInMemoryOnly {
            let config = ModelConfiguration(schema: resolvedSchema, isStoredInMemoryOnly: true)
            if let container = try? ModelContainer(for: resolvedSchema, configurations: [config]) {
                return container
            }
        }

        let targetURL: URL
        if let storeURL = storeURL {
            targetURL = storeURL
        } else if let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            targetURL = appSupport.appendingPathComponent("default.store")
        } else {
            targetURL = FileManager.default.temporaryDirectory.appendingPathComponent("default.store")
        }

        let persistentConfig = ModelConfiguration(
            schema: resolvedSchema,
            url: targetURL,
            allowsSave: true,
            cloudKitDatabase: .none
        )

        do {
            return try ModelContainer(for: resolvedSchema, configurations: [persistentConfig])
        } catch {
            print("ModelContainer initialization failed for \(targetURL): \(error). Backing up store files...")
            backupStoreFiles(at: targetURL)

            do {
                return try ModelContainer(for: resolvedSchema, configurations: [persistentConfig])
            } catch {
                print("Persistent ModelContainer recovery failed: \(error). Falling back to in-memory container.")
                let fallbackConfig = ModelConfiguration(schema: resolvedSchema, isStoredInMemoryOnly: true)
                if let fallbackContainer = try? ModelContainer(for: resolvedSchema, configurations: [fallbackConfig]) {
                    return fallbackContainer
                }
                let memoryOnly = ModelConfiguration(schema: resolvedSchema, isStoredInMemoryOnly: true)
                return try! ModelContainer(for: resolvedSchema, configurations: [memoryOnly])
            }
        }
    }

    public static func backupStoreFiles(at storeURL: URL) {
        let fileManager = FileManager.default
        let directory = storeURL.deletingLastPathComponent()
        let baseName = storeURL.lastPathComponent
        let timestamp = Int(Date().timeIntervalSince1970)

        let extensions = ["", "-shm", "-wal"]
        for ext in extensions {
            let sourceURL = ext.isEmpty ? storeURL : directory.appendingPathComponent("\(baseName)\(ext)")
            if fileManager.fileExists(atPath: sourceURL.path) {
                let backupURL = directory.appendingPathComponent("\(baseName)\(ext).corrupt-\(timestamp).bak")
                try? fileManager.moveItem(at: sourceURL, to: backupURL)
            }
        }
    }
}
