import Foundation
import SwiftData

struct ConversionSeedService {
    static func seedInitialDataIfNeeded(modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<ConversionRecord>()
        let existingCount = (try? modelContext.fetchCount(fetchDescriptor)) ?? 0
        
        guard existingCount == 0 else { return }
        
        let seeds: [ConversionRecord] = [
            ConversionRecord(
                fileId: "0417",
                fileName: "hero-banner.png",
                inputFormat: .png,
                dimensions: PixelDimensions(width: 4096, height: 2731),
                outputFormat: .webp,
                outputSizeBytes: 684_000,
                project: "Marketing",
                status: .working,
                timestamp: Date()
            ),
            ConversionRecord(
                fileId: "0416",
                fileName: "product-shot.jpg",
                inputFormat: .jpg,
                dimensions: PixelDimensions(width: 2400, height: 1600),
                outputFormat: .avif,
                outputSizeBytes: 412_000,
                project: "Storefront",
                status: .working,
                timestamp: Date().addingTimeInterval(-60)
            ),
            ConversionRecord(
                fileId: "0415",
                fileName: "brand-mark.svg",
                inputFormat: .svg,
                dimensions: PixelDimensions(width: 1200, height: 1200),
                outputFormat: .png,
                outputSizeBytes: 96_000,
                project: "Brand",
                status: .working,
                timestamp: Date().addingTimeInterval(-120)
            ),
            ConversionRecord(
                fileId: "0414",
                fileName: "event-poster.tiff",
                inputFormat: .tif,
                dimensions: PixelDimensions(width: 3000, height: 4500),
                outputFormat: .jpg,
                outputSizeBytes: 1_200_000,
                project: "Events",
                status: .done,
                timestamp: Date().addingTimeInterval(-180)
            ),
            ConversionRecord(
                fileId: "0413",
                fileName: "launch-grid.jpg",
                inputFormat: .jpg,
                dimensions: PixelDimensions(width: 2048, height: 1365),
                outputFormat: .webp,
                outputSizeBytes: 328_000,
                project: "Campaign",
                status: .working,
                timestamp: Date().addingTimeInterval(-240)
            ),
            ConversionRecord(
                fileId: "0412",
                fileName: "product-detail.png",
                inputFormat: .png,
                dimensions: PixelDimensions(width: 1800, height: 2400),
                outputFormat: .avif,
                outputSizeBytes: 221_000,
                project: "Storefront",
                status: .working,
                timestamp: Date().addingTimeInterval(-240)
            )
        ]
        
        for item in seeds {
            modelContext.insert(item)
        }
        
        try? modelContext.save()
    }
}
