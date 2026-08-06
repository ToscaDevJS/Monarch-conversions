import SwiftUI

struct ConvertScene: View {
    var onSelectTab: ((AppTab) -> Void)? = nil
    
    @State private var items: [BatchQueueItem] = [
        BatchQueueItem(name: "hero-banner.png", format: .png, dimensions: PixelDimensions(width: 4096, height: 2731), originalSizeBytes: 2_800_000, targetFormat: .webp, targetSizeBytes: 420_000),
        BatchQueueItem(name: "product-shot.jpg", format: .jpg, dimensions: PixelDimensions(width: 2400, height: 1600), originalSizeBytes: 4_100_000, targetFormat: .avif, targetSizeBytes: 780_000),
        BatchQueueItem(name: "product-detail.png", format: .png, dimensions: PixelDimensions(width: 1800, height: 2400), originalSizeBytes: 1_500_000, targetFormat: .webp, targetSizeBytes: 210_000),
        BatchQueueItem(name: "brand-mark.svg", format: .svg, dimensions: PixelDimensions(width: 1200, height: 1200), originalSizeBytes: 450_000, targetFormat: .svg, targetSizeBytes: 85_000)
    ]
    
    @State private var selectedId: UUID? = nil
    
    var selectedItem: BatchQueueItem? {
        if let selectedId = selectedId {
            return items.first(where: { $0.id == selectedId })
        }
        return items.first
    }

    private var originalSizeText: String {
        guard let item = selectedItem else { return "ORIGINAL: 2.8 MB" }
        return "ORIGINAL: \(ConversionFormatting.byteSize(item.originalSizeBytes))"
    }

    private var targetFormatText: String {
        guard let item = selectedItem else { return "WEBP OPTIMIZED" }
        return "\(item.targetFormat.rawValue.uppercased()) OPTIMIZED"
    }

    private var targetSizeText: String {
        guard let item = selectedItem,
              let targetBytes = item.targetSizeBytes,
              let pct = item.reductionPercent else {
            return "WEBP: 420 KB (-85%)"
        }
        let formatStr = item.targetFormat.rawValue.uppercased()
        let sizeStr = ConversionFormatting.byteSize(targetBytes)
        let pctStr = ConversionFormatting.reduction(percent: pct)
        return "\(formatStr): \(sizeStr) (\(pctStr))"
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
                            originalSizeText: originalSizeText,
                            targetFormatText: targetFormatText,
                            targetSizeText: targetSizeText
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
