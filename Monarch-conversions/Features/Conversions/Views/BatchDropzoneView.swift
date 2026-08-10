import SwiftUI

struct BatchDropzoneView: View {
    var onBrowse: (() -> Void)? = nil
    var onDropFiles: (([URL]) -> Void)? = nil

    @State private var isTargeted = false

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 28))
                .foregroundStyle(MonarchUI.Color.accentViolet)

            Text("dropzone.title", tableName: "Conversions")
                .font(MonarchUI.Font.sans(size: 20, weight: .medium))
                .foregroundStyle(MonarchUI.Color.textPrimary)

            Text("dropzone.subtitle", tableName: "Conversions")
                .font(MonarchUI.Font.sans(size: 13))
                .foregroundStyle(MonarchUI.Color.textSubtle)

            Button {
                onBrowse?()
            } label: {
                Text("action.browse", tableName: "Common")
                    .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                    .padding(.horizontal, 14)
                    .frame(height: 32)
                    .background(MonarchUI.Color.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            
            Text("dropzone.limit", tableName: "Conversions")
                .font(MonarchUI.Font.mono(size: 10))
                .foregroundStyle(MonarchUI.Color.textDim)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(isTargeted ? MonarchUI.Color.accentVioletBg : MonarchUI.Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(
                    isTargeted ? MonarchUI.Color.accentViolet : MonarchUI.Color.surfaceBorder,
                    style: StrokeStyle(lineWidth: isTargeted ? 2 : 1, dash: isTargeted ? [] : [4, 4])
                )
        )
        .dropDestination(for: URL.self) { urls, _ in
            guard !urls.isEmpty else { return false }
            onDropFiles?(urls)
            return true
        } isTargeted: { targeted in
            isTargeted = targeted
        }
    }
}

#Preview {
    BatchDropzoneView()
        .padding()
        .background(MonarchUI.Color.background)
}
