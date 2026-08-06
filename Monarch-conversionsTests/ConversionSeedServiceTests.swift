import Testing
import SwiftData
import Foundation
@testable import Monarch_conversions

@Suite struct ConversionSeedServiceTests {
    @Test func seedInitialDataIsIdempotentAndTyped() async throws {
        let schema = Schema([ConversionRecord.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)

        // Seed once
        ConversionSeedService.seedInitialDataIfNeeded(modelContext: context)

        let fetch1 = FetchDescriptor<ConversionRecord>()
        let records1 = try context.fetch(fetch1)
        #expect(records1.count == 6)

        // Seed twice (idempotent)
        ConversionSeedService.seedInitialDataIfNeeded(modelContext: context)

        let records2 = try context.fetch(fetch1)
        #expect(records2.count == 6)

        // Check hero-banner.png record
        guard let hero = records2.first(where: { $0.fileName == "hero-banner.png" }) else {
            Issue.record("hero-banner.png record not found")
            return
        }

        #expect(hero.inputFormat == .png)
        #expect(hero.outputFormat == .webp)
        #expect(hero.dimensions == PixelDimensions(width: 4096, height: 2731))
        #expect(hero.outputSizeBytes == 684_000)
        #expect(ConversionFormatting.byteSize(hero.outputSizeBytes) == "684 KB")
        #expect(hero.status == .working)
    }
}
