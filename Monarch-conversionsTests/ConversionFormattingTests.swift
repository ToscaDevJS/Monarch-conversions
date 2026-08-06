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

    @Test func reductionFormatting() {
        #expect(ConversionFormatting.reduction(percent: -85) == "-85%")
        #expect(ConversionFormatting.reduction(percent: 0) == "0%")
    }
}
