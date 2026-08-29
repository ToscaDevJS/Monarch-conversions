import Foundation
import SwiftData

public struct ModelContainerFactory {
    /// Builds the app's SwiftData container without ever destroying existing data.
    ///
    /// Resolution order: the requested store, then the same store once a damaged file
    /// has been moved aside, then an in-memory store. A damaged store is renamed to
    /// `.corrupt-<timestamp>.bak`, never deleted.
    public static func createContainer(
        schema: Schema? = nil,
        storeURL: URL? = nil,
        isStoredInMemoryOnly: Bool = false
    ) -> ModelContainer {
        let resolvedSchema = schema ?? Schema([ConversionRecord.self])

        guard !isStoredInMemoryOnly else {
            return inMemoryContainer(for: resolvedSchema)
        }

        let targetURL = storeURL ?? defaultStoreURL()
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
        }

        do {
            return try ModelContainer(for: resolvedSchema, configurations: [persistentConfig])
        } catch {
            print("Persistent ModelContainer recovery failed: \(error). Falling back to in-memory container.")
            return inMemoryContainer(for: resolvedSchema)
        }
    }

    /// The last resort. An in-memory container can only fail when the schema itself is
    /// invalid, which is a build-time defect rather than a runtime condition, so this
    /// names the offending schema instead of trapping anonymously.
    private static func inMemoryContainer(for schema: Schema) -> ModelContainer {
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            preconditionFailure("Invalid SwiftData schema, no in-memory container could be built: \(error)")
        }
    }

    private static func defaultStoreURL() -> URL {
        if let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            return appSupport.appendingPathComponent("default.store")
        }
        return FileManager.default.temporaryDirectory.appendingPathComponent("default.store")
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
