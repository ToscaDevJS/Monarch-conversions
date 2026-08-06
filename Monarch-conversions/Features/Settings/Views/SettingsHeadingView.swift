import SwiftUI

struct SettingsHeadingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("WORKSPACE / SETTINGS")
                .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                .foregroundStyle(MonarchUI.Color.textSecondary)
                .tracking(0.5)
            
            Text("Personal preferences")
                .font(MonarchUI.Font.sans(size: 24, weight: .semibold))
                .foregroundStyle(MonarchUI.Color.textPrimary)
            
            Text("Control how Monarch looks, feels, and communicates with you.")
                .font(MonarchUI.Font.sans(size: 14))
                .foregroundStyle(MonarchUI.Color.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 24)
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
