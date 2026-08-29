import Testing
import Foundation
@testable import Monarch_conversions

@Suite struct ImportOutcomeTests {
    @Test func acceptedOutcomeHoldsBatchQueueItem() {
        let item = BatchQueueItem(
            name: "photo.jpg",
            format: .jpg,
            dimensions: PixelDimensions(width: 1920, height: 1080),
            originalSizeBytes: 2_048_000
        )
        let outcome = ImportOutcome.accepted(item)

        switch outcome {
        case .accepted(let payload):
            #expect(payload.name == "photo.jpg")
            #expect(payload.format == .jpg)
            #expect(payload.dimensions.width == 1920)
            #expect(payload.dimensions.height == 1080)
            #expect(payload.originalSizeBytes == 2_048_000)
            #expect(payload == item)
        case .rejected:
            Issue.record("Expected .accepted outcome, got .rejected")
        }
    }

    @Test func rejectedOutcomeHoldsImportRejection() {
        let rejection = ImportRejection(
            fileName: "unsupported.gif",
            reason: .unsupportedType(fileExtension: "gif")
        )
        let outcome = ImportOutcome.rejected(rejection)

        switch outcome {
        case .accepted:
            Issue.record("Expected .rejected outcome, got .accepted")
        case .rejected(let payload):
            #expect(payload.fileName == "unsupported.gif")
            #expect(payload.reason == .unsupportedType(fileExtension: "gif"))
            #expect(payload == rejection)
        }
    }

    @Test func rejectedOutcomeWithAllReasonVariants() {
        let fileTooLargeRejection = ImportRejection(
            fileName: "huge.png",
            reason: .fileTooLarge(sizeBytes: 200_000_000, limitBytes: 100_000_000)
        )
        let batchLimitRejection = ImportRejection(
            fileName: "extra.png",
            reason: .batchLimitExceeded(limit: 50)
        )
        let unreadableRejection = ImportRejection(
            fileName: "corrupt.png",
            reason: .unreadable
        )

        let outcomeTooLarge = ImportOutcome.rejected(fileTooLargeRejection)
        let outcomeBatchLimit = ImportOutcome.rejected(batchLimitRejection)
        let outcomeUnreadable = ImportOutcome.rejected(unreadableRejection)

        if case .rejected(let r) = outcomeTooLarge {
            #expect(r.reason == .fileTooLarge(sizeBytes: 200_000_000, limitBytes: 100_000_000))
        } else {
            Issue.record("Expected rejected with fileTooLarge")
        }

        if case .rejected(let r) = outcomeBatchLimit {
            #expect(r.reason == .batchLimitExceeded(limit: 50))
        } else {
            Issue.record("Expected rejected with batchLimitExceeded")
        }

        if case .rejected(let r) = outcomeUnreadable {
            #expect(r.reason == .unreadable)
        } else {
            Issue.record("Expected rejected with unreadable")
        }
    }

    @Test func equatableConformanceForAcceptedOutcomes() {
        let id = UUID()
        let item1 = BatchQueueItem(
            id: id,
            name: "image.png",
            format: .png,
            dimensions: PixelDimensions(width: 800, height: 600),
            originalSizeBytes: 4096
        )
        let item2 = BatchQueueItem(
            id: id,
            name: "image.png",
            format: .png,
            dimensions: PixelDimensions(width: 800, height: 600),
            originalSizeBytes: 4096
        )
        let itemDifferent = BatchQueueItem(
            name: "different.png",
            format: .png,
            dimensions: PixelDimensions(width: 800, height: 600),
            originalSizeBytes: 4096
        )

        let outcome1 = ImportOutcome.accepted(item1)
        let outcome2 = ImportOutcome.accepted(item2)
        let outcomeDifferent = ImportOutcome.accepted(itemDifferent)

        #expect(outcome1 == outcome2)
        #expect(outcome1 != outcomeDifferent)
    }

    @Test func equatableConformanceForRejectedOutcomes() {
        let id = UUID()
        let rejection1 = ImportRejection(
            id: id,
            fileName: "bad.xyz",
            reason: .unsupportedType(fileExtension: "xyz")
        )
        let rejection2 = ImportRejection(
            id: id,
            fileName: "bad.xyz",
            reason: .unsupportedType(fileExtension: "xyz")
        )
        let rejectionDifferent = ImportRejection(
            fileName: "other.xyz",
            reason: .unsupportedType(fileExtension: "xyz")
        )

        let outcome1 = ImportOutcome.rejected(rejection1)
        let outcome2 = ImportOutcome.rejected(rejection2)
        let outcomeDifferent = ImportOutcome.rejected(rejectionDifferent)

        #expect(outcome1 == outcome2)
        #expect(outcome1 != outcomeDifferent)
    }

    @Test func inequalityBetweenDifferentCases() {
        let item = BatchQueueItem(
            name: "test.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 1024
        )
        let rejection = ImportRejection(
            fileName: "test.png",
            reason: .unreadable
        )

        let acceptedOutcome = ImportOutcome.accepted(item)
        let rejectedOutcome = ImportOutcome.rejected(rejection)

        #expect(acceptedOutcome != rejectedOutcome)
    }

    @Test func sendableAcrossConcurrencyBoundaries() async {
        let item = BatchQueueItem(
            name: "async.png",
            format: .png,
            dimensions: PixelDimensions(width: 200, height: 200),
            originalSizeBytes: 512
        )
        let outcome = ImportOutcome.accepted(item)

        let result = await Task.detached { () -> ImportOutcome in
            return outcome
        }.value

        #expect(result == outcome)
    }
}
