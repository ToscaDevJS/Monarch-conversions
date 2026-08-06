import SwiftUI

struct BatchQueueView: View {
    @Binding var items: [BatchQueueItem]
    @Binding var selectedId: UUID?
    var onClearAll: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("BATCH QUEUE (\(items.count) FILES)")
                    .font(MonarchUI.Font.mono(size: 11, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.accentViolet)
                    .tracking(0.8)
                
                Spacer()
                
                Button {
                    onClearAll?()
                } label: {
                    Text("Clear all")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(SwiftUI.Color(hex: "#8F8F8F"))
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 4)
            .overlay(
                Rectangle()
                    .fill(MonarchUI.Color.divider)
                    .frame(height: 1),
                alignment: .bottom
            )
            
            VStack(spacing: 8) {
                ForEach(items) { item in
                    BatchQueueItemRow(
                        item: BatchQueueItem(
                            name: item.name,
                            format: item.format,
                            dimensions: item.dimensions,
                            originalSize: item.originalSize,
                            targetFormat: item.targetFormat,
                            targetSize: item.targetSize,
                            reductionPercentage: item.reductionPercentage,
                            isSelected: selectedId == item.id
                        )
                    ) {
                        selectedId = item.id
                    }
                }
            }
        }
    }
}
