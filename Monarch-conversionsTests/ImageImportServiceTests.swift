import Foundation
import Testing
@testable import Monarch_conversions

@Suite struct ImageImportServiceTests {
    private var fixturesURL: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures")
    }

    private func fixtureURL(_ name: String) -> URL {
        fixturesURL.appendingPathComponent(name)
    }

    @Test(arguments: [
        "sample.png",
        "sample.jpg",
        "sample.tif",
        "sample.heic",
        "sample.jp2",
        "sample.webp",
        "sample.avif",
        "sample.jxl"
    ]) func acceptsSupportedFormatsWithMetadata(name: String) async {
        let service = ImageImportService()
        let url = fixtureURL(name)
        let outcomes = await service.importFiles(at: [url], existingCount: 0)

        #expect(outcomes.count == 1)
        guard let outcome = outcomes.first else { return }
        switch outcome {
        case .accepted(let item):
            #expect(item.name == name)
            #expect(item.dimensions.width == 400)
            #expect(item.dimensions.height == 300)
            #expect(item.originalSizeBytes > 0)
            #expect(item.targetFormat == nil)
        case .rejected(let rejection):
            Issue.record("Expected \(name) to be accepted, but was rejected with \(rejection.reason)")
        }
    }

    @Test func verifiesPngExactMetadata() async throws {
        let service = ImageImportService()
        let pngURL = fixtureURL("sample.png")
        let outcomes = await service.importFiles(at: [pngURL], existingCount: 0)

        #expect(outcomes.count == 1)
        guard case .accepted(let item) = outcomes.first else {
            Issue.record("Expected sample.png to be accepted")
            return
        }

        let fileValues = try pngURL.resourceValues(forKeys: [.fileSizeKey])
        let expectedSize = Int64(fileValues.fileSize ?? 0)

        #expect(item.name == "sample.png")
        #expect(item.format == .png)
        #expect(item.dimensions.width == 400)
        #expect(item.dimensions.height == 300)
        #expect(item.originalSizeBytes == expectedSize)
    }

    @Test func rejectsUnsupportedTypes() async {
        let service = ImageImportService()
        let svgURL = fixtureURL("sample.svg")

        let outcomes = await service.importFiles(at: [svgURL], existingCount: 0)

        #expect(outcomes.count == 1)
        guard case .rejected(let rejection) = outcomes.first else {
            Issue.record("Expected sample.svg to be rejected")
            return
        }

        #expect(rejection.fileName == "sample.svg")
        #expect(rejection.reason == .unsupportedType(fileExtension: "svg"))
    }

    @Test func rejectsFileTooLarge() async {
        let service = ImageImportService(maxFileSizeBytes: 1_000)
        let tifURL = fixtureURL("sample.tif")

        let outcomes = await service.importFiles(at: [tifURL], existingCount: 0)

        #expect(outcomes.count == 1)
        guard case .rejected(let rejection) = outcomes.first else {
            Issue.record("Expected sample.tif to be rejected for size")
            return
        }

        #expect(rejection.fileName == "sample.tif")
        if case .fileTooLarge(let sizeBytes, let limitBytes) = rejection.reason {
            #expect(sizeBytes > 1_000)
            #expect(limitBytes == 1_000)
        } else {
            Issue.record("Expected .fileTooLarge reason, got \(rejection.reason)")
        }
    }

    @Test func enforcesBatchLimitAndIgnoresInvalidFilesForCapacity() async {
        let service = ImageImportService(maxBatchCount: 2)
        let urls = [
            fixtureURL("sample.svg"), // Invalid extension - should not consume capacity slot
            fixtureURL("sample.png"), // Valid 1 (existing 1 + 1 = 2) -> Accepted
            fixtureURL("sample.jpg")  // Valid 2 (existing 1 + 2 = 3 > 2) -> Rejected capacity limit
        ]

        let outcomes = await service.importFiles(at: urls, existingCount: 1)

        #expect(outcomes.count == 3)
        guard case .rejected(let rej1) = outcomes[0] else {
            Issue.record("Expected sample.svg to be rejected")
            return
        }
        #expect(rej1.reason == .unsupportedType(fileExtension: "svg"))

        guard case .accepted(let item1) = outcomes[1] else {
            Issue.record("Expected sample.png to be accepted")
            return
        }
        #expect(item1.name == "sample.png")

        guard case .rejected(let rej2) = outcomes[2] else {
            Issue.record("Expected sample.jpg to be rejected due to batch limit")
            return
        }
        #expect(rej2.reason == .batchLimitExceeded(limit: 2))
    }

    @Test func handlesCorruptFilesAndPreservesInputOrder() async {
        let service = ImageImportService()
        let urls = [
            fixtureURL("sample.png"),
            fixtureURL("corrupt.png"),
            fixtureURL("sample.jpg")
        ]

        let outcomes = await service.importFiles(at: urls, existingCount: 0)

        #expect(outcomes.count == 3)
        guard case .accepted(let item0) = outcomes[0] else {
            Issue.record("Expected outcomes[0] to be accepted")
            return
        }
        #expect(item0.name == "sample.png")

        guard case .rejected(let rej1) = outcomes[1] else {
            Issue.record("Expected outcomes[1] to be rejected as corrupt/unreadable")
            return
        }
        #expect(rej1.fileName == "corrupt.png")
        #expect(rej1.reason == .unreadable)

        guard case .accepted(let item2) = outcomes[2] else {
            Issue.record("Expected outcomes[2] to be accepted")
            return
        }
        #expect(item2.name == "sample.jpg")
    }
}
