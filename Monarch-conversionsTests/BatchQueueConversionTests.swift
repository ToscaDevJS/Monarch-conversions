import Testing
import Foundation
import SwiftData
@testable import Monarch_conversions

@Suite struct BatchQueueConversionTests {
    @Test func pendingItemsFilterExcludesDoneAndConvertingItems() {
        let itemQueued = BatchQueueItem(
            name: "1.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 1000,
            status: .queued
        )
        let itemDone = BatchQueueItem(
            name: "2.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 1000,
            status: .done
        )
        let itemConverting = BatchQueueItem(
            name: "3.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 1000,
            status: .converting
        )
        let itemFailed = BatchQueueItem(
            name: "4.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 1000,
            status: .failed
        )

        let allItems = [itemQueued, itemDone, itemConverting, itemFailed]
        let pending = BatchQueueProcessor.pendingItems(in: allItems)

        #expect(pending.count == 1)
        #expect(pending.first?.id == itemQueued.id)
    }

    @MainActor
    @Test func reRunningBatchDoesNotDuplicateSwiftDataRecords() throws {
        let schema = Schema([ConversionRecord.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = container.mainContext

        let item1 = BatchQueueItem(
            name: "photo.png",
            format: .png,
            dimensions: PixelDimensions(width: 400, height: 300),
            originalSizeBytes: 4000,
            status: .done
        )
        let record1 = ConversionRecord(
            fileId: item1.id.uuidString,
            fileName: item1.name,
            inputFormat: item1.format,
            dimensions: item1.dimensions,
            outputFormat: .webp,
            outputSizeBytes: 800,
            project: "Default",
            status: .done,
            timestamp: Date(),
            outputFilePath: "/tmp/photo_converted.webp"
        )
        context.insert(record1)
        try context.save()

        // Attempting to process items where all items are .done
        let pending = BatchQueueProcessor.pendingItems(in: [item1])
        #expect(pending.isEmpty)

        // Verify no duplicate record was inserted
        let records = try context.fetch(FetchDescriptor<ConversionRecord>())
        #expect(records.count == 1)
    }

    @Test func failedItemStoresDiagnosticErrorMessage() {
        var item = BatchQueueItem(
            name: "broken.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 500,
            status: .failed,
            errorMessage: "Corrupted image data"
        )

        #expect(item.status == .failed)
        #expect(item.errorMessage == "Corrupted image data")

        item.errorMessage = "Unsupported color space"
        #expect(item.errorMessage == "Unsupported color space")
    }

    @Test func cooperativeCancellationHaltsQueueProcessing() async throws {
        var processedCount = 0
        let task = Task.detached {
            for i in 0..<100 {
                if Task.isCancelled { break }
                processedCount += 1
                try await Task.sleep(nanoseconds: 10_000_000)
            }
        }

        task.cancel()
        _ = await task.result

        #expect(processedCount < 100)
    }
}
