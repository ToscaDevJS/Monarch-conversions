import Foundation
import Testing
@testable import Monarch_conversions

@Suite struct TableFilteringTests {
    private var sampleRecords: [ConversionRecord] {
        [
            ConversionRecord(
                id: "1",
                fileId: "FILE-1",
                fileName: "hero.png",
                inputFormat: .png,
                dimensions: PixelDimensions(width: 4000, height: 3000),
                outputFormat: .webp,
                outputSizeBytes: 500_000,
                project: "Marketing",
                status: .done
            ),
            ConversionRecord(
                id: "2",
                fileId: "FILE-2",
                fileName: "avatar.jpg",
                inputFormat: .jpg,
                dimensions: PixelDimensions(width: 800, height: 800),
                outputFormat: .avif,
                outputSizeBytes: 40_000,
                project: "CoreApp",
                status: .working
            ),
            ConversionRecord(
                id: "3",
                fileId: "FILE-3",
                fileName: "banner.tif",
                inputFormat: .tif,
                dimensions: PixelDimensions(width: 1920, height: 1080),
                outputFormat: .png,
                outputSizeBytes: 1_200_000,
                project: "Marketing",
                status: .done
            )
        ]
    }

    @Test func returnsAllRecordsWhenFilterIsDefault() {
        let state = TableFilterState()
        #expect(!state.isActive)

        let filtered = sampleRecords.filtered(with: state)
        #expect(filtered.count == 3)
    }

    @Test func filtersByStatus() {
        var state = TableFilterState()
        state.status = .working
        #expect(state.isActive)

        let filtered = sampleRecords.filtered(with: state)
        #expect(filtered.count == 1)
        #expect(filtered.first?.fileName == "avatar.jpg")
    }

    @Test func filtersByInputAndProjectCombined() {
        var state = TableFilterState()
        state.inputFormat = .png
        state.project = "Marketing"
        #expect(state.isActive)

        let filtered = sampleRecords.filtered(with: state)
        #expect(filtered.count == 1)
        #expect(filtered.first?.fileId == "FILE-1")
    }

    @Test func resetsFilterStateToAll() {
        var state = TableFilterState(status: .done, inputFormat: .tif, outputFormat: .png, project: "Marketing")
        #expect(state.isActive)

        state.reset()
        #expect(!state.isActive)
        #expect(state.status == nil)
        #expect(state.inputFormat == nil)
        #expect(state.outputFormat == nil)
        #expect(state.project == nil)

        let filtered = sampleRecords.filtered(with: state)
        #expect(filtered.count == 3)
    }
}
