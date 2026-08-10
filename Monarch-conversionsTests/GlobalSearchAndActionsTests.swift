import Foundation
import Testing
import AppKit
@testable import Monarch_conversions

@Suite struct GlobalSearchAndActionsTests {
    private var sampleRecords: [ConversionRecord] {
        [
            ConversionRecord(
                id: "1",
                fileId: "BATCH-101",
                fileName: "landscape_photo.png",
                inputFormat: .png,
                dimensions: PixelDimensions(width: 3840, height: 2160),
                outputFormat: .webp,
                outputSizeBytes: 350_000,
                project: "Photography",
                status: .done
            ),
            ConversionRecord(
                id: "2",
                fileId: "BATCH-102",
                fileName: "user_avatar.jpg",
                inputFormat: .jpg,
                dimensions: PixelDimensions(width: 512, height: 512),
                outputFormat: .avif,
                outputSizeBytes: 18_000,
                project: "MobileApp",
                status: .done
            )
        ]
    }

    @Test func matchesFileNameSubstringCaseInsensitive() {
        var state = TableFilterState()
        state.searchText = "PHOTO"

        let results = sampleRecords.filtered(with: state)
        #expect(results.count == 1)
        #expect(results.first?.fileName == "landscape_photo.png")
    }

    @Test func matchesFileIdSubstring() {
        var state = TableFilterState()
        state.searchText = "102"

        let results = sampleRecords.filtered(with: state)
        #expect(results.count == 1)
        #expect(results.first?.fileId == "BATCH-102")
    }

    @Test func matchesProjectSubstring() {
        var state = TableFilterState()
        state.searchText = "mobile"

        let results = sampleRecords.filtered(with: state)
        #expect(results.count == 1)
        #expect(results.first?.project == "MobileApp")
    }

    @Test func verifiesNSPasteboardCopying() {
        let testFileName = "test_clipboard_image.png"
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(testFileName, forType: .string)

        let pasted = NSPasteboard.general.string(forType: .string)
        #expect(pasted == testFileName)
    }
}
