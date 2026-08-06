import SwiftUI

struct SettingsHeadingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("WORKSPACE / SETTINGS")
                .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                .foregroundStyle(MonarchUI.Color.accentViolet)
                .tracking(0.8)
            
            Text("Personal preferences")
                .font(MonarchUI.Font.sans(size: 32, weight: .medium))
                .foregroundStyle(MonarchUI.Color.textPrimary)
                .tracking(-0.5)
            
            Text("Control how Monarch looks, feels, and communicates with you.")
                .font(MonarchUI.Font.sans(size: 14))
                .foregroundStyle(MonarchUI.Color.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 34)
        .padding(.bottom, 24)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.divider)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

#Preview {
    SettingsHeadingView()
        .padding()
        .background(MonarchUI.Color.background)
}
