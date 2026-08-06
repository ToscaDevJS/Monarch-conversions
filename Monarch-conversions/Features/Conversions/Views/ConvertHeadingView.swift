import SwiftUI

struct ConvertHeadingView: View {
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 6) {
                Text("WORKSPACE / NEW CONVERSION")
                    .font(MonarchUI.Font.mono(size: 11, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.accentViolet)
                    .tracking(0.8)
                
                Text("Convert & Optimize Images")
                    .font(MonarchUI.Font.sans(size: 28, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                    .tracking(-0.5)
                
                Text("Upload single files or multi-image batches with Squoosh-style visual quality inspector.")
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
            }
            
            Spacer()
            
            Text("Supported: JPG, PNG, WebP, AVIF, TIFF, SVG")
                .font(MonarchUI.Font.mono(size: 12))
                .foregroundStyle(SwiftUI.Color(hex: "#8F8F8F"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 28)
        .padding(.bottom, 20)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.divider)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

#Preview {
    ConvertHeadingView()
        .padding()
        .background(MonarchUI.Color.background)
}
