import SwiftUI

struct AppearancePanelView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Appearance")
                    .font(MonarchUI.Font.sans(size: 16, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                Text("Choose the color scheme for your workspace.")
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
            }
            
            HStack(spacing: 16) {
                // Dark Option Card
                AppearanceCard(
                    title: "Dark",
                    badge: settings.appearance == .dark ? "ACTIVE" : nil,
                    isSelected: settings.appearance == .dark,
                    isDarkPreview: true
                ) {
                    settings.appearance = .dark
                }
                
                // Light Option Card
                AppearanceCard(
                    title: "Light",
                    badge: settings.appearance == .light ? "ACTIVE" : nil,
                    isSelected: settings.appearance == .light,
                    isDarkPreview: false
                ) {
                    settings.appearance = .light
                }
                
                // System Option Card
                VStack(alignment: .leading, spacing: 8) {
                    Text("SYSTEM SETTING")
                        .font(MonarchUI.Font.sans(size: 11, weight: .bold))
                        .foregroundStyle(MonarchUI.Color.textSecondary)
                    Text("Use device preference")
                        .font(MonarchUI.Font.sans(size: 13))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                .padding(16)
                .frame(width: 160, height: 104, alignment: .topLeading)
                .background(
                    Rectangle()
                        .fill(settings.appearance == .system ? MonarchUI.Color.surface : MonarchUI.Color.background)
                )
                .overlay(
                    Rectangle()
                        .stroke(settings.appearance == .system ? MonarchUI.Color.accentViolet : MonarchUI.Color.divider, lineWidth: 1)
                )
                .onTapGesture {
                    settings.appearance = .system
                }
            }
        }
        .padding(20)
        .background(
            Rectangle()
                .fill(MonarchUI.Color.surface)
        )
        .overlay(
            Rectangle()
                .stroke(MonarchUI.Color.surfaceBorder, lineWidth: 1)
        )
    }
}

private struct AppearanceCard: View {
    let title: String
    let badge: String?
    let isSelected: Bool
    let isDarkPreview: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                // Visual Mockup Preview Box
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(isDarkPreview ? SwiftUI.Color(hex: "#1A1A1A") : SwiftUI.Color(hex: "#E5E5E5"))
                        .frame(width: 24, height: 26)
                    Rectangle()
                        .fill(isDarkPreview ? SwiftUI.Color(hex: "#262626") : SwiftUI.Color(hex: "#D4D4D4"))
                        .frame(width: 46, height: 26)
                    Rectangle()
                        .fill(isDarkPreview ? SwiftUI.Color(hex: "#333333") : SwiftUI.Color(hex: "#C0C0C0"))
                        .frame(width: 66, height: 26)
                }
                .frame(width: 152, height: 42)
                .background(isDarkPreview ? SwiftUI.Color(hex: "#090909") : SwiftUI.Color(hex: "#FFFFFF"))
                
                HStack {
                    Text(title)
                        .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    
                    Spacer()
                    
                    if let badge = badge {
                        Text(badge)
                            .font(MonarchUI.Font.sans(size: 10, weight: .bold))
                            .foregroundStyle(MonarchUI.Color.accentViolet)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(MonarchUI.Color.accentVioletBg)
                            .overlay(
                                Rectangle()
                                    .stroke(MonarchUI.Color.accentVioletBorder, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(14)
            .frame(width: 180, height: 104)
            .background(
                Rectangle()
                    .fill(isSelected ? MonarchUI.Color.background : MonarchUI.Color.surface)
            )
            .overlay(
                Rectangle()
                    .stroke(isSelected ? MonarchUI.Color.accentViolet : MonarchUI.Color.divider, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AppearancePanelView(settings: UserSettings())
        .padding()
        .background(MonarchUI.Color.background)
}
