import Testing
import Foundation
import SwiftData
@testable import Monarch_conversions

@Suite struct DashboardHistoryPreservationTests {
    @MainActor
    @Test func recordsWithMarketingAndCommonNamesArePreserved() throws {
        let schema = Schema([ConversionRecord.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = container.mainContext

        let record1 = ConversionRecord(
            id: "rec-1",
            fileId: "F1",
            fileName: "team-photo.png",
            inputFormat: .png,
            dimensions: PixelDimensions(width: 1920, height: 1080),
            outputFormat: .webp,
            outputSizeBytes: 300_000,
            project: "Marketing",
            status: .done,
            timestamp: Date()
        )
        let record2 = ConversionRecord(
            id: "rec-2",
            fileId: "F2",
            fileName: "hero-banner.png",
            inputFormat: .png,
            dimensions: PixelDimensions(width: 4096, height: 2731),
            outputFormat: .avif,
            outputSizeBytes: 450_000,
            project: "Storefront",
            status: .done,
            timestamp: Date()
        )
        let record3 = ConversionRecord(
            id: "rec-3",
            fileId: "F3",
            fileName: "product-shot.jpg",
            inputFormat: .jpg,
            dimensions: PixelDimensions(width: 1200, height: 800),
            outputFormat: .webp,
            outputSizeBytes: 120_000,
            project: "Brand",
            status: .done,
            timestamp: Date()
        )

        context.insert(record1)
        context.insert(record2)
        context.insert(record3)
        try context.save()

        let descriptor = FetchDescriptor<ConversionRecord>()
        let fetched = try context.fetch(descriptor)
        #expect(fetched.count == 3)
        #expect(fetched.contains(where: { $0.fileName == "team-photo.png" && $0.project == "Marketing" }))
        #expect(fetched.contains(where: { $0.fileName == "hero-banner.png" && $0.project == "Storefront" }))
        #expect(fetched.contains(where: { $0.fileName == "product-shot.jpg" && $0.project == "Brand" }))
    }
}
