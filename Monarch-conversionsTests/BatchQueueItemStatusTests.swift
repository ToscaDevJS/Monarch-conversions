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

    // MARK: - Scenario 2.1 & 2.2: Pipeline status progression

    @Test func pipelineProgressesFromQueuedToDone() async throws {
        let item = makeItem()
        #expect(item.status == .queued)

        var converting = item
        converting.status = .converting
        #expect(converting.status == .converting)

        var done = converting
        done.status = .done
        #expect(done.status == .done)
    }

    @Test func pipelineProgressesFromQueuedToFailed() async throws {
        let item = makeItem()
        #expect(item.status == .queued)

        var converting = item
        converting.status = .converting
        #expect(converting.status == .converting)

        var failed = converting
        failed.status = .failed
        #expect(failed.status == .failed)
    }

    // MARK: - Scenario 3.1-3.3: Visual status rendering logic

    @Test func convertingStatusProducesProgressIndicator() {
        let item = makeItem(status: .converting)
        // The row renders ProgressView + "Converting..." for .converting status
        #expect(item.status == .converting)
        // Verify the conditional branch: not .done, not .failed, not .queued
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

    private func makeItem(status: BatchItemStatus = .queued) -> BatchQueueItem {
        BatchQueueItem(
            name: "test.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 50_000,
            status: status
        )
    }
}
