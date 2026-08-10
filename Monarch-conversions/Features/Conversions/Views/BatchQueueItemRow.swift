import SwiftUI

struct BatchQueueItemRow: View {
    let item: BatchQueueItem
    let isSelected: Bool
    let onSelect: () -> Void
    
    private var trailingText: String {
        guard let targetFormat = item.targetFormat else {
            return "No target"
        }
        if let targetBytes = item.targetSizeBytes, let pct = item.reductionPercent {
            let sizeStr = ConversionFormatting.byteSize(targetBytes)
            let pctStr = ConversionFormatting.reduction(percent: pct)
            return "\(targetFormat.rawValue) · \(sizeStr) (\(pctStr))"
        } else {
            return targetFormat.rawValue
        }
    }

    var body: some View {
        Button(action: onSelect) {
            HStack {
                HStack(spacing: 10) {
                    Text(item.format.rawValue.uppercased())
                        .font(MonarchUI.Font.sans(size: 8, weight: .bold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .frame(width: 26, height: 26)
                        .background(MonarchUI.Color.badgeGrayBg)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        Text("\(ConversionFormatting.dimensions(item.dimensions)) · \(ConversionFormatting.byteSize(item.originalSizeBytes))")
                            .font(MonarchUI.Font.mono(size: 11))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Text(trailingText)
                        .font(MonarchUI.Font.sans(size: 11, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.accentVioletBg)
                        .padding(.horizontal, 8)
                        .frame(height: 22)
                        .background(MonarchUI.Color.accentViolet)
                        .clipShape(Capsule())
                } else {
                    Text(trailingText)
                        .font(MonarchUI.Font.mono(size: 11))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
            }
            .padding(12)
            .background(isSelected ? MonarchUI.Color.accentVioletBg : MonarchUI.Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(isSelected ? MonarchUI.Color.accentViolet : MonarchUI.Color.divider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
