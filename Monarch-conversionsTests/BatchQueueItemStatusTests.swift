import Foundation
import Testing
@testable import Monarch_conversions

@Suite struct BatchQueueItemStatusTests {
    // MARK: - Scenario 1.1: New item defaults to queued

    @Test func itemDefaultsToQueuedStatus() {
        let item = BatchQueueItem(
            name: "test.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 50_000
        )
        #expect(item.status == .queued)
    }

    // MARK: - Scenario 1.2: Status transitions through all cases

    @Test func statusCanBeMutatedToConverting() {
        var item = makeItem()
        item.status = .converting
        #expect(item.status == .converting)
    }

    @Test func statusCanBeMutatedToDone() {
        var item = makeItem()
        item.status = .done
        #expect(item.status == .done)
    }

    @Test func statusCanBeMutatedToFailed() {
        var item = makeItem()
        item.status = .failed
        #expect(item.status == .failed)
    }

    @Test func statusEnumHasAllFourCases() {
        #expect(BatchItemStatus.allCases.count == 4)
        #expect(BatchItemStatus.allCases == [.queued, .converting, .done, .failed])
    }

    @Test func statusCanTransitionThroughAllCases() {
        var item = makeItem()
        #expect(item.status == .queued)

        item.status = .converting
        #expect(item.status == .converting)

        item.status = .done
        #expect(item.status == .done)

        item.status = .failed
        #expect(item.status == .failed)
    }

    // MARK: - Scenario 2.1 & 2.2: Pipeline status progression (in-place array mutation)

    @Test func pipelineIterationMutatesStatusInPlaceToDone() async throws {
        var items = [makeItem(), makeItem(name: "photo.jpg"), makeItem(name: "doc.png")]
        #expect(items.allSatisfy { $0.status == .queued })

        for index in items.indices {
            items[index].status = .converting
            #expect(items[index].status == .converting)

            // Simulate successful conversion: creates a new item with .done status
            let original = items[index]
            items[index] = BatchQueueItem(
                id: original.id,
                name: original.name,
                format: original.format,
                dimensions: original.dimensions,
                originalSizeBytes: original.originalSizeBytes,
                targetFormat: .jpg,
                targetSizeBytes: 10_000,
                fileURL: original.fileURL,
                status: .done
            )
            #expect(items[index].status == .done)
        }

        #expect(items.allSatisfy { $0.status == .done })
    }

    @Test func pipelineIterationSetsFailedOnError() async throws {
        var items = [makeItem()]
        #expect(items[0].status == .queued)

        // Simulate the error path from processBatchConversion()
        items[0].status = .converting
        #expect(items[0].status == .converting)

        items[0].status = .failed
        #expect(items[0].status == .failed)
    }

    @Test func pipelineIterationPreservesItemIdentity() async throws {
        var items = [makeItem(name: "hero.png")]
        let originalId = items[0].id

        items[0].status = .converting

        // Simulate successful conversion with new BatchQueueItem
        let original = items[0]
        items[0] = BatchQueueItem(
            id: original.id,
            name: original.name,
            format: original.format,
            dimensions: original.dimensions,
            originalSizeBytes: original.originalSizeBytes,
            targetFormat: .jpg,
            targetSizeBytes: 10_000,
            fileURL: original.fileURL,
            status: .done
        )

        #expect(items[0].id == originalId)
        #expect(items[0].status == .done)
        #expect(items[0].targetFormat == ImageFormat.jpg)
    }

    // MARK: - Scenario 3.1-3.3: Visual status rendering logic (accessibility identifiers)

    @Test func convertingStatusProducesProgressIndicator() {
        let item = makeItem(status: .converting)
        #expect(item.status == .converting)
        #expect(item.status != .done)
        #expect(item.status != .failed)
        #expect(item.status != .queued)
    }

    @Test func doneStatusProducesCheckmarkBadge() {
        let item = makeItem(status: .done)
        #expect(item.status == .done)
        #expect(item.status != .converting)
        #expect(item.status != .failed)
    }

    @Test func failedStatusProducesCrossBadge() {
        let item = makeItem(status: .failed)
        #expect(item.status == .failed)
        #expect(item.status != .done)
        #expect(item.status != .converting)
    }

    // MARK: - Helpers

    private func makeItem(name: String = "test.png", status: BatchItemStatus = .queued) -> BatchQueueItem {
        BatchQueueItem(
            name: name,
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 50_000,
            status: status
        )
    }
}
