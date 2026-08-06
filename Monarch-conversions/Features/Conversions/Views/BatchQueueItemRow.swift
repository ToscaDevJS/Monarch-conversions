import SwiftUI

struct BatchQueueItemRow: View {
    let item: BatchQueueItem
    let isSelected: Bool
    let onSelect: () -> Void
    
    private var trailingText: String {
        if let targetBytes = item.targetSizeBytes, let pct = item.reductionPercent {
            let sizeStr = ConversionFormatting.byteSize(targetBytes)
            let pctStr = ConversionFormatting.reduction(percent: pct)
            return "\(item.targetFormat.rawValue) · \(sizeStr) (\(pctStr))"
        } else {
            return item.targetFormat.rawValue
        }
    }

    var body: some View {
        Button(action: onSelect) {
            HStack {
                HStack(spacing: 10) {
                    Text(item.format.rawValue.uppercased())
                        .font(MonarchUI.Font.sans(size: 8, weight: .bold))
                        .foregroundStyle(SwiftUI.Color.white)
                        .frame(width: 26, height: 26)
                        .background(SwiftUI.Color(hex: "#414141"))
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                            .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                        Text("\(ConversionFormatting.dimensions(item.dimensions)) · \(ConversionFormatting.byteSize(item.originalSizeBytes))")
                            .font(MonarchUI.Font.mono(size: 11))
                            .foregroundStyle(SwiftUI.Color(hex: "#8F8F8F"))
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
                        .foregroundStyle(SwiftUI.Color(hex: "#8F8F8F"))
                }
            }
            .padding(12)
            .background(isSelected ? SwiftUI.Color(hex: "#1A1720") : SwiftUI.Color(hex: "#101010"))
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(isSelected ? MonarchUI.Color.accentViolet : SwiftUI.Color(hex: "#292929"), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
