import Foundation
import Testing
@testable import Monarch_conversions

@Suite struct SquooshInspectorViewTests {
    @Test func acceptsFileURLAndInitializes() {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("sample_preview.png")
        let view = SquooshInspectorView(
            fileName: "sample_preview.png",
            originalSizeText: "ORIGINAL: 1.2 MB",
            targetFormatText: "WEBP OPTIMIZED",
            targetSizeText: "WEBP: 300 KB (-75%)",
            imageURL: tempURL
        )

        #expect(view.fileName == "sample_preview.png")
        #expect(view.imageURL == tempURL)
    }

    @Test func acceptsOutputImageURLAndSeparatesOriginalAndConvertedURLs() {
        let sourceURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("source.png")
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output_converted.webp")
        let view = SquooshInspectorView(
            fileName: "source.png",
            originalSizeText: "ORIGINAL: 1.2 MB",
            targetFormatText: "WEBP OPTIMIZED",
            targetSizeText: "WEBP: 300 KB (-75%)",
            imageURL: sourceURL,
            outputImageURL: outputURL
        )

        #expect(view.imageURL == sourceURL)
        #expect(view.outputImageURL == outputURL)
    }
}
