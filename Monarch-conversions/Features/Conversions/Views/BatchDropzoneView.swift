import SwiftUI

struct BatchDropzoneView: View {
    var onBrowse: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "photo.badge.plus")
                .font(.system(size: 28))
                .foregroundStyle(MonarchUI.Color.accentViolet)
            
            Text("Drop images here for batch conversion")
                .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                .foregroundStyle(MonarchUI.Color.textPrimary)
            
            Text("or choose files from your computer")
                .font(MonarchUI.Font.sans(size: 12))
                .foregroundStyle(MonarchUI.Color.textSecondary)
            
            Button {
                onBrowse?()
            } label: {
                Text("Browse files")
                    .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                    .padding(.horizontal, 14)
                    .frame(height: 32)
                    .background(SwiftUI.Color(hex: "#171717"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(SwiftUI.Color(hex: "#4B4B4B"), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            
            Text("Batch limit: 50 files · Max 100 MB per file")
                .font(MonarchUI.Font.mono(size: 10))
                .foregroundStyle(SwiftUI.Color(hex: "#777777"))
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(SwiftUI.Color(hex: "#101010"))
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(SwiftUI.Color(hex: "#404040"), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
        )
    }
}

#Preview {
    BatchDropzoneView()
        .padding()
        .background(MonarchUI.Color.background)
}
