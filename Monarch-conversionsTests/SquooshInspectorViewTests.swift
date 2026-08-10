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
}
