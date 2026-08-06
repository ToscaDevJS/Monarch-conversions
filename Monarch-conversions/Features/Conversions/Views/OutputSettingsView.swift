import SwiftUI

struct OutputSettingsView: View {
    @State private var format: String = "WebP"
    @State private var quality: String = "82 / High"
    @State private var dimensions: String = "Keep original (4096px)"
    @State private var metadata: String = "Remove EXIF"
    var onAddBatch: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Output settings")
                    .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                
                Spacer()
                
                Text("Workspace preset: WebP High")
                    .font(MonarchUI.Font.mono(size: 11))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
            }
            
            HStack(spacing: 10) {
                // Format Box (Selected)
                VStack(alignment: .leading, spacing: 4) {
                    Text("FORMAT")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(MonarchUI.Color.accentViolet)
                        .tracking(0.5)
                    HStack {
                        Text("\(format) ⌄")
                            .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                    }
                }
                .padding(.horizontal, 12)
                .frame(width: 180, height: 70, alignment: .leading)
                .background(MonarchUI.Color.accentVioletBg)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.accentViolet, lineWidth: 1)
                )
                
                // Quality Box
                VStack(alignment: .leading, spacing: 4) {
                    Text("QUALITY")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(SwiftUI.Color(hex: "#9A9A9A"))
                        .tracking(0.5)
                    Text(quality)
                        .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                .padding(.horizontal, 12)
                .frame(width: 180, height: 70, alignment: .leading)
                .background(SwiftUI.Color(hex: "#141414"))
                .overlay(
                    Rectangle()
                        .stroke(SwiftUI.Color(hex: "#343434"), lineWidth: 1)
                )
                
                // Dimensions Box
                VStack(alignment: .leading, spacing: 4) {
                    Text("DIMENSIONS")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(SwiftUI.Color(hex: "#9A9A9A"))
                        .tracking(0.5)
                    Text(dimensions)
                        .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                .padding(.horizontal, 12)
                .frame(width: 230, height: 70, alignment: .leading)
                .background(SwiftUI.Color(hex: "#141414"))
                .overlay(
                    Rectangle()
                        .stroke(SwiftUI.Color(hex: "#343434"), lineWidth: 1)
                )
                
                // Metadata Box
                VStack(alignment: .leading, spacing: 4) {
                    Text("METADATA")
                        .font(MonarchUI.Font.sans(size: 11))
                        .foregroundStyle(SwiftUI.Color(hex: "#9A9A9A"))
                        .tracking(0.5)
                    Text(metadata)
                        .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                .padding(.horizontal, 12)
                .frame(height: 70)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(SwiftUI.Color(hex: "#141414"))
                .overlay(
                    Rectangle()
                        .stroke(SwiftUI.Color(hex: "#343434"), lineWidth: 1)
                )
            }
            
            HStack {
                HStack(spacing: 8) {
                    Text("Total batch estimated savings:")
                        .font(MonarchUI.Font.sans(size: 13))
                        .foregroundStyle(MonarchUI.Color.textSecondary)
                    
                    Text("8.85 MB → 1.49 MB (-83%)")
                        .font(MonarchUI.Font.mono(size: 13, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.accentViolet)
                }
                
                Spacer()
                
                Button {
                    onAddBatch?()
                } label: {
                    Text("Add batch to conversion queue")
                        .font(MonarchUI.Font.sans(size: 14, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.accentVioletBg)
                        .padding(.horizontal, 28)
                        .frame(height: 42)
                        .background(MonarchUI.Color.accentViolet)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 4)
        }
        .padding(18)
        .background(SwiftUI.Color(hex: "#101010"))
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(SwiftUI.Color(hex: "#303030"), lineWidth: 1)
        )
    }
}

#Preview {
    OutputSettingsView()
        .padding()
        .background(MonarchUI.Color.background)
}
