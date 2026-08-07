import Testing
@testable import Monarch_conversions

@Suite struct ImageFormatTests {
    @Test func rawValueRoundTrips() {
        #expect(ImageFormat(rawValue: "PNG") == .png)
        #expect(ImageFormat(rawValue: "JPG") == .jpg)
        #expect(ImageFormat(rawValue: "WebP") == .webp)
        #expect(ImageFormat(rawValue: "AVIF") == .avif)
        #expect(ImageFormat(rawValue: "SVG") == .svg)
        #expect(ImageFormat(rawValue: "TIF") == .tif)
        #expect(ImageFormat(rawValue: "HEIC") == .heic)
        #expect(ImageFormat(rawValue: "JP2") == .jpeg2000)
        #expect(ImageFormat(rawValue: "JXL") == .jpegXL)

        #expect(ImageFormat.png.rawValue == "PNG")
        #expect(ImageFormat.jpg.rawValue == "JPG")
        #expect(ImageFormat.webp.rawValue == "WebP")
        #expect(ImageFormat.avif.rawValue == "AVIF")
        #expect(ImageFormat.svg.rawValue == "SVG")
        #expect(ImageFormat.tif.rawValue == "TIF")
        #expect(ImageFormat.heic.rawValue == "HEIC")
        #expect(ImageFormat.jpeg2000.rawValue == "JP2")
        #expect(ImageFormat.jpegXL.rawValue == "JXL")
    }

    @Test func unknownRawValueIsNil() {
        #expect(ImageFormat(rawValue: "BMP") == nil)
    }

    @Test func initFromFileExtension() {
        #expect(ImageFormat(fileExtension: "png") == .png)
        #expect(ImageFormat(fileExtension: "PNG") == .png)
        #expect(ImageFormat(fileExtension: "jpg") == .jpg)
        #expect(ImageFormat(fileExtension: "jpeg") == .jpg)
        #expect(ImageFormat(fileExtension: "JPEG") == .jpg)
        #expect(ImageFormat(fileExtension: "webp") == .webp)
        #expect(ImageFormat(fileExtension: "avif") == .avif)
        #expect(ImageFormat(fileExtension: "svg") == .svg)
        #expect(ImageFormat(fileExtension: "tif") == .tif)
        #expect(ImageFormat(fileExtension: "tiff") == .tif)
        #expect(ImageFormat(fileExtension: "TIFF") == .tif)
        #expect(ImageFormat(fileExtension: "heic") == .heic)
        #expect(ImageFormat(fileExtension: "HEIC") == .heic)
        #expect(ImageFormat(fileExtension: "heif") == .heic)
        #expect(ImageFormat(fileExtension: "jp2") == .jpeg2000)
        #expect(ImageFormat(fileExtension: "j2k") == .jpeg2000)
        #expect(ImageFormat(fileExtension: "jpf") == .jpeg2000)
        #expect(ImageFormat(fileExtension: "jxl") == .jpegXL)
        #expect(ImageFormat(fileExtension: "JXL") == .jpegXL)
        #expect(ImageFormat(fileExtension: "bmp") == nil)
    }

    @Test func pixelDimensionsHoldsNumericComponents() {
        let dim = PixelDimensions(width: 4096, height: 2731)
        #expect(dim.width == 4096)
        #expect(dim.height == 2731)
    }

    @Test func outputEligibleCasesExcludeDecodeOnlyFormats() {
        #expect(!ImageFormat.outputEligibleCases.contains(.webp))
        #expect(!ImageFormat.outputEligibleCases.contains(.jpegXL))
        #expect(ImageFormat.outputEligibleCases.contains(.png))
        #expect(ImageFormat.outputEligibleCases.contains(.heic))
    }
}
