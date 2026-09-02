import SwiftUI

/// Reusable chrome for individual output configuration boxes.
struct OutputSettingBox<Content: View>: View {
    let title: Text
    var titleColor: SwiftUI.Color = MonarchUI.Color.textSubtle
    var isSelected: Bool = false
    var width: CGFloat? = nil
    @ViewBuilder let content: () -> Content

    init(
        title: Text,
        titleColor: SwiftUI.Color = MonarchUI.Color.textSubtle,
        isSelected: Bool = false,
        width: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.titleColor = titleColor
        self.isSelected = isSelected
        self.width = width
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            title
                .font(MonarchUI.Font.sans(size: 11))
                .foregroundStyle(isSelected ? MonarchUI.Color.accentViolet : titleColor)
                .tracking(0.5)

            content()
        }
        .padding(.horizontal, 12)
        .frame(height: 70, alignment: .leading)
        .frame(width: width, alignment: .leading)
        .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
        .background(isSelected ? MonarchUI.Color.accentVioletBg : MonarchUI.Color.surface)
        .overlay(
            Rectangle()
                .stroke(isSelected ? MonarchUI.Color.accentViolet : MonarchUI.Color.fieldBorder, lineWidth: 1)
        )
    }
}
