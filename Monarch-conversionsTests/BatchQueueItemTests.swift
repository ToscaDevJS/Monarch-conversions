import Testing
import Foundation
@testable import Monarch_conversions

@Suite struct BatchQueueItemTests {
    @Test func reductionPercentCalculation() {
        let item1 = BatchQueueItem(
            name: "test.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 1000,
            targetFormat: .webp,
            targetSizeBytes: 150
        )
        #expect(item1.reductionPercent == -85)

        let itemZero = BatchQueueItem(
            name: "zero.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 0,
            targetFormat: .webp,
            targetSizeBytes: 150
        )
        #expect(itemZero.reductionPercent == 0)

        let itemRounding = BatchQueueItem(
            name: "round.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 1000,
            targetFormat: .webp,
            targetSizeBytes: 147
        )
        #expect(itemRounding.reductionPercent == -85)

        let itemNilTarget = BatchQueueItem(
            name: "pending.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 1000,
            targetFormat: .webp,
            targetSizeBytes: nil
        )
        #expect(itemNilTarget.reductionPercent == nil)

        let itemMockBanner = BatchQueueItem(
            name: "hero-banner.png",
            format: .png,
            dimensions: PixelDimensions(width: 4096, height: 2731),
            originalSizeBytes: 2_800_000,
            targetFormat: .webp,
            targetSizeBytes: 420_000
        )
        #expect(itemMockBanner.reductionPercent == -85)
    }
}
