import Testing
@testable import Monarch_conversions

@Suite struct ConversionFormattingTests {
    @Test func byteSizeFormatting() {
        #expect(ConversionFormatting.byteSize(684_000) == "684 KB")
        #expect(ConversionFormatting.byteSize(412_000) == "412 KB")
        #expect(ConversionFormatting.byteSize(96_000) == "96 KB")
        #expect(ConversionFormatting.byteSize(420_000) == "420 KB")
        #expect(ConversionFormatting.byteSize(1_200_000) == "1.2 MB")
        #expect(ConversionFormatting.byteSize(2_800_000) == "2.8 MB")
        #expect(ConversionFormatting.byteSize(4_100_000) == "4.1 MB")
    }

    @Test func dimensionsFormatting() {
        let dim = PixelDimensions(width: 4096, height: 2731)
        #expect(ConversionFormatting.dimensions(dim) == "4096 × 2731")
    }

    @Test func shortFileIdFormatting() {
        #expect(ConversionFormatting.shortFileId("0784F5C9-0536-4940-ACB6-CF2C9C966F08") == "0784F5C9")
        #expect(ConversionFormatting.shortFileId("BATCH-101") == "BATCH-10")
        #expect(ConversionFormatting.shortFileId("0417") == "0417")
    }

    @Test func reductionFormatting() {
        #expect(ConversionFormatting.reduction(percent: -85) == "-85%")
        #expect(ConversionFormatting.reduction(percent: 0) == "0%")
    }

    @Test func rejectionMessageFormatting() {
        let unsupported = ImportRejection.Reason.unsupportedType(fileExtension: "svg")
        #expect(ConversionFormatting.rejectionMessage(unsupported) == "Unsupported format (.svg)")

        let tooLarge = ImportRejection.Reason.fileTooLarge(sizeBytes: 150_000_000, limitBytes: 100_000_000)
        #expect(ConversionFormatting.rejectionMessage(tooLarge) == "File exceeds 100.0 MB limit (150.0 MB)")

        let batchLimit = ImportRejection.Reason.batchLimitExceeded(limit: 50)
        #expect(ConversionFormatting.rejectionMessage(batchLimit) == "Batch limit of 50 files reached")

        let unreadable = ImportRejection.Reason.unreadable
        #expect(ConversionFormatting.rejectionMessage(unreadable) == "File could not be read or decoded")
    }
}

