import Foundation
import Testing
@testable import Monarch_conversions

@Suite struct MetricsHeaderViewTests {
    private var sampleRecords: [ConversionRecord] {
        [
            ConversionRecord(
                id: "1",
                fileId: "F1",
                fileName: "one.png",
                inputFormat: .png,
                dimensions: PixelDimensions(width: 100, height: 100),
                outputFormat: .webp,
                outputSizeBytes: 100_000,
                project: "Project A",
                status: .done,
                timestamp: Date()
            ),
            ConversionRecord(
                id: "2",
                fileId: "F2",
                fileName: "two.jpg",
                inputFormat: .jpg,
                dimensions: PixelDimensions(width: 200, height: 200),
                outputFormat: .avif,
                outputSizeBytes: 50_000,
                project: "Project B",
                status: .working,
                timestamp: Date()
            )
        ]
    }

    @Test func calculatesUniqueProjectsAndWorkingCount() {
        let uniqueProjects = Set(sampleRecords.map { $0.project })
        #expect(uniqueProjects.count == 2)

        let workingCount = sampleRecords.filter { $0.status == .working }.count
        #expect(workingCount == 1)

        let doneCount = sampleRecords.filter { $0.status == .done && Calendar.current.isDateInToday($0.timestamp) }.count
        #expect(doneCount == 1)
    }
}
