import SwiftUI

struct ConvertScene: View {
    var onSelectTab: ((AppTab) -> Void)? = nil
    
    @State private var items: [BatchQueueItem] = [
        BatchQueueItem(name: "hero-banner.png", format: "PNG", dimensions: "4096 × 2731", originalSize: "2.8 MB", targetFormat: "WebP", targetSize: "420 KB", reductionPercentage: "-85%"),
        BatchQueueItem(name: "product-shot.jpg", format: "JPG", dimensions: "2400 × 1600", originalSize: "4.1 MB", targetFormat: "AVIF", targetSize: "780 KB", reductionPercentage: "-81%"),
        BatchQueueItem(name: "product-detail.png", format: "PNG", dimensions: "1800 × 2400", originalSize: "1.5 MB", targetFormat: "WebP", targetSize: "210 KB", reductionPercentage: "-86%"),
        BatchQueueItem(name: "brand-mark.svg", format: "SVG", dimensions: "1200 × 1200", originalSize: "450 KB", targetFormat: "SVG", targetSize: "85 KB", reductionPercentage: "-81%")
    ]
    
    @State private var selectedId: UUID? = nil
    
    var selectedItem: BatchQueueItem? {
        if let selectedId = selectedId {
            return items.first(where: { $0.id == selectedId })
        }
        return items.first
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                TopNavHeaderView(activeTab: .convert, onSelectTab: onSelectTab)
                
                ConvertHeadingView()
                
                HStack(alignment: .top, spacing: 24) {
                    // Left Column (Dropzone & Batch Queue)
                    VStack(alignment: .leading, spacing: 20) {
                        BatchDropzoneView()
                        
                        BatchQueueView(
                            items: $items,
                            selectedId: $selectedId,
                            onClearAll: {
                                items.removeAll()
                            }
                        )
                    }
                    .frame(width: 460)
                    
                    // Right Column (Visual Inspector & Output Settings)
                    VStack(alignment: .leading, spacing: 20) {
                        SquooshInspectorView(
                            fileName: selectedItem?.name ?? "hero-banner.png",
                            originalSizeText: "ORIGINAL: \(selectedItem?.originalSize ?? "2.8 MB")",
                            targetFormatText: "\(selectedItem?.targetFormat.uppercased() ?? "WEBP") OPTIMIZED",
                            targetSizeText: "\(selectedItem?.targetFormat.uppercased() ?? "WEBP"): \(selectedItem?.targetSize ?? "420 KB") (\(selectedItem?.reductionPercentage ?? "-85%"))"
                        )
                        
                        OutputSettingsView()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 24)
            }
            .padding(28)
            .background(MonarchUI.Color.background)
            
            Spacer(minLength: 0)
            
            VStack(spacing: 0) {
                TelemetryFooterView()
                StatusFooterView()
            }
        }
        .background(MonarchUI.Color.background)
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            if selectedId == nil {
                selectedId = items.first?.id
            }
        }
    }
}

#Preview {
    ConvertScene()
}
