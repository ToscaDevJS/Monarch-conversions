import SwiftUI

struct BatchQueueView: View {
    @Binding var items: [BatchQueueItem]
    @Binding var selectedId: UUID?
    var onClearAll: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("queue.title \(items.count)", tableName: "Conversions")
                    .font(MonarchUI.Font.mono(size: 11, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.accentViolet)
                    .tracking(0.8)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
                
                Button {
                    onClearAll?()
                } label: {
                    Text("action.clear_all", tableName: "Common")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(MonarchUI.Color.textMuted)
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
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(items) { item in
                        BatchQueueItemRow(
                            item: item,
                            isSelected: selectedId == item.id
                        ) {
                            selectedId = item.id
                        }
                    }
                }
            }
            .frame(maxHeight: 340)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("batch-queue")
    }
}
