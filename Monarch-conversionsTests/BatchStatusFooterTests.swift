import Testing
import Foundation
@testable import Monarch_conversions

@Suite struct BatchStatusFooterTests {

    @Test func emptyQueueProducesZeroBytesAndNilReduction() {
        let footer = BatchStatusFooterView(
            items: [],
            settings: ConversionSettings(),
            isProcessing: false
        )

        #expect(footer.totalOriginalBytes == 0)
        #expect(footer.doneItems.isEmpty)
        #expect(footer.doneOriginalBytes == 0)
        #expect(footer.doneOutputBytes == 0)
        #expect(footer.totalSavedBytes == 0)
        #expect(footer.totalReductionPct == nil)
    }

    @Test func calculatesAccurateSavedBytesAndReductionPercentage() {
        let item1 = BatchQueueItem(
            name: "image1.png",
            format: .png,
            dimensions: PixelDimensions(width: 1000, height: 1000),
            originalSizeBytes: 10_000,
            targetFormat: .webp,
            targetSizeBytes: 2_000,
            status: .done
        )

        let item2 = BatchQueueItem(
            name: "image2.jpg",
            format: .jpg,
            dimensions: PixelDimensions(width: 2000, height: 2000),
            originalSizeBytes: 20_000,
            targetFormat: .webp,
            targetSizeBytes: 4_000,
            status: .done
        )

        let pendingItem = BatchQueueItem(
            name: "pending.png",
            format: .png,
            dimensions: PixelDimensions(width: 500, height: 500),
            originalSizeBytes: 5_000,
            status: .queued
        )

        let footer = BatchStatusFooterView(
            items: [item1, item2, pendingItem],
            settings: ConversionSettings(targetFormat: .webp, quality: 0.8),
            isProcessing: false
        )

        #expect(footer.totalOriginalBytes == 35_000)
        #expect(footer.doneItems.count == 2)
        #expect(footer.doneOriginalBytes == 30_000)
        #expect(footer.doneOutputBytes == 6_000)
        #expect(footer.totalSavedBytes == 24_000)
        // (6000 - 30000) / 30000 = -80%
        #expect(footer.totalReductionPct == -80)
    }

    @Test func activeProcessingStateReflectsProperFlags() {
        let footer = BatchStatusFooterView(
            items: [],
            settings: ConversionSettings(targetFormat: .avif, quality: 0.9),
            isProcessing: true
        )

        #expect(footer.isProcessing == true)
        #expect(footer.settings.targetFormat == .avif)
        #expect(footer.settings.quality == 0.9)
    }
}
