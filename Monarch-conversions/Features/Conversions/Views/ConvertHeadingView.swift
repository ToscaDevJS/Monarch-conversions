import SwiftUI

struct ConvertHeadingView: View {
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 6) {
                Text("WORKSPACE / NEW CONVERSION")
                    .font(MonarchUI.Font.mono(size: 11, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.accentViolet)
                    .tracking(0.8)
                
                Text("header.convert_title", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 32, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                    .tracking(-0.5)
                
                Text("header.convert_subtitle", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 14))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
            }
            
            Spacer()
            
            Text("convert.supported_formats", tableName: "Conversions")
                .font(MonarchUI.Font.sans(size: 12))
                .foregroundStyle(MonarchUI.Color.textMuted)
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
