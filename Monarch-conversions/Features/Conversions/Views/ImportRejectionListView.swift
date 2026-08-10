import SwiftUI

public struct ImportRejectionListView: View {
    public let rejections: [ImportRejection]
    public let onDismiss: () -> Void

    public init(rejections: [ImportRejection], onDismiss: @escaping () -> Void) {
        self.rejections = rejections
        self.onDismiss = onDismiss
    }

    public var body: some View {
        if !rejections.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(SwiftUI.Color(hex: "#FF453A"))
                            .font(.system(size: 11))
                        Text("rejection.title \(rejections.count)", tableName: "Conversions")
                            .font(MonarchUI.Font.sans(size: 11, weight: .bold))
                            .foregroundStyle(SwiftUI.Color(hex: "#FF453A"))
                    }

                    Spacer()

                    Button(action: onDismiss) {
                        Text("action.dismiss", tableName: "Common")
                            .font(MonarchUI.Font.sans(size: 11, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                    }
                    .buttonStyle(.plain)
                }

                VStack(spacing: 4) {
                    ForEach(rejections) { rejection in
                        HStack {
                            Text(rejection.fileName)
                                .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                                .foregroundStyle(MonarchUI.Color.textPrimary)
                                .lineLimit(1)

                            Spacer()

                            Text(ConversionFormatting.rejectionMessage(rejection.reason))
                                .font(MonarchUI.Font.mono(size: 11))
                                .foregroundStyle(SwiftUI.Color(hex: "#FF6259"))
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(SwiftUI.Color(hex: "#1A1414"))
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    }
                }
            }
            .padding(12)
            .background(SwiftUI.Color(hex: "#141010"))
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(SwiftUI.Color(hex: "#3D1C1C"), lineWidth: 1)
            )
        }
    }
}
