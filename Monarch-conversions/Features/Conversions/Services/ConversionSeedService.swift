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
                inputFormat: "PNG",
                dimensions: "4096 × 2731",
                outputFormat: "WebP",
                outputSize: "684 KB",
                project: "Marketing",
                status: .working,
                timestamp: Date()
            ),
            ConversionRecord(
                fileId: "0416",
                fileName: "product-shot.jpg",
                inputFormat: "JPG",
                dimensions: "2400 × 1600",
                outputFormat: "AVIF",
                outputSize: "412 KB",
                project: "Storefront",
                status: .working,
                timestamp: Date().addingTimeInterval(-60)
            ),
            ConversionRecord(
                fileId: "0415",
                fileName: "brand-mark.svg",
                inputFormat: "SVG",
                dimensions: "1200 × 1200",
                outputFormat: "PNG",
                outputSize: "96 KB",
                project: "Brand",
                status: .working,
                timestamp: Date().addingTimeInterval(-120)
            ),
            ConversionRecord(
                fileId: "0414",
                fileName: "event-poster.tiff",
                inputFormat: "TIF",
                dimensions: "3000 × 4500",
                outputFormat: "JPG",
                outputSize: "1.2 MB",
                project: "Events",
                status: .done,
                timestamp: Date().addingTimeInterval(-180)
            ),
            ConversionRecord(
                fileId: "0413",
                fileName: "launch-grid.jpg",
                inputFormat: "JPG",
                dimensions: "2048 × 1365",
                outputFormat: "WebP",
                outputSize: "328 KB",
                project: "Campaign",
                status: .working,
                timestamp: Date().addingTimeInterval(-240)
            ),
            ConversionRecord(
                fileId: "0412",
                fileName: "product-detail.png",
                inputFormat: "PNG",
                dimensions: "1800 × 2400",
                outputFormat: "AVIF",
                outputSize: "221 KB",
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
