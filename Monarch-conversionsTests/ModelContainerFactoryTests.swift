import Testing
import Foundation
import SwiftData
@testable import Monarch_conversions

@Suite struct ModelContainerFactoryTests {
    private var temporaryDirectoryURL: URL {
        FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    }

    @MainActor
    @Test func createsStandardPersistentContainer() throws {
        let tempDir = temporaryDirectoryURL
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let storeURL = tempDir.appendingPathComponent("default.store")
        let container = ModelContainerFactory.createContainer(storeURL: storeURL)

        let record = ConversionRecord(
            id: "rec-1",
            fileId: "F1",
            fileName: "test.png",
            inputFormat: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            outputFormat: .webp,
            outputSizeBytes: 1024,
            project: "Test",
            status: .done,
            timestamp: Date()
        )
        container.mainContext.insert(record)
        try container.mainContext.save()

        let fetched = try container.mainContext.fetch(FetchDescriptor<ConversionRecord>())
        #expect(fetched.count == 1)
        #expect(fetched.first?.fileName == "test.png")
    }

    @MainActor
    @Test func backsUpCorruptedStoreAndInitializesNewContainerWithoutDeletingOldData() throws {
        let tempDir = temporaryDirectoryURL
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let storeURL = tempDir.appendingPathComponent("default.store")
        let corruptData = "CORRUPTED_SQLITE_HEADER_DATA_THAT_FAILS_SCHEMA_INIT".data(using: .utf8)!
        try corruptData.write(to: storeURL)

        // The factory should move the corrupt file to a .bak backup and produce a working container
        let container = ModelContainerFactory.createContainer(storeURL: storeURL)

        // Verify a backup file was created containing the original corrupted bytes
        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil)
        let backupFiles = contents.filter { $0.lastPathComponent.contains(".bak") }

        #expect(!backupFiles.isEmpty)
        if let firstBackup = backupFiles.first {
            let backupData = try Data(contentsOf: firstBackup)
            #expect(backupData == corruptData)
        }

        // Verify the container is fully functional
        let record = ConversionRecord(
            id: "rec-recovered",
            fileId: "FR",
            fileName: "recovered.png",
            inputFormat: .png,
            dimensions: PixelDimensions(width: 200, height: 200),
            outputFormat: .avif,
            outputSizeBytes: 2048,
            project: "Recovered",
            status: .done,
            timestamp: Date()
        )
        container.mainContext.insert(record)
        try container.mainContext.save()

        let fetched = try container.mainContext.fetch(FetchDescriptor<ConversionRecord>())
        #expect(fetched.count == 1)
        #expect(fetched.first?.fileName == "recovered.png")
    }

    @MainActor
    @Test func fallsBackToInMemoryContainerWhenStorageDirectoryIsUnwritable() {
        let readOnlyURL = URL(fileURLWithPath: "/System/Library/MonarchUnwritableStore/default.store")
        let container = ModelContainerFactory.createContainer(storeURL: readOnlyURL)

        // Should return a valid in-memory container without crashing with fatalError
        let record = ConversionRecord(
            id: "rec-inmem",
            fileId: "FM",
            fileName: "inmemory.png",
            inputFormat: .png,
            dimensions: PixelDimensions(width: 50, height: 50),
            outputFormat: .jpg,
            outputSizeBytes: 512,
            project: "InMemory",
            status: .done,
            timestamp: Date()
        )
        container.mainContext.insert(record)
        #expect(throws: Never.self) {
            try container.mainContext.save()
        }
    }

    @MainActor
    @Test func inMemoryRequestNeverWritesToTheStoreURL() throws {
        let tempDir = temporaryDirectoryURL
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let storeURL = tempDir.appendingPathComponent("default.store")
        let container = ModelContainerFactory.createContainer(storeURL: storeURL, isStoredInMemoryOnly: true)

        let record = ConversionRecord(
            id: "rec-inmem-only",
            fileId: "FIO",
            fileName: "memory-only.png",
            inputFormat: .png,
            dimensions: PixelDimensions(width: 64, height: 64),
            outputFormat: .jpg,
            outputSizeBytes: 256,
            project: "InMemoryOnly",
            status: .done,
            timestamp: Date()
        )
        container.mainContext.insert(record)
        try container.mainContext.save()

        let fetched = try container.mainContext.fetch(FetchDescriptor<ConversionRecord>())
        #expect(fetched.count == 1)

        let leftovers = try FileManager.default.contentsOfDirectory(atPath: tempDir.path)
        #expect(leftovers.isEmpty)
    }
}
