import SwiftUI

struct AppearancePanelView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("settings.section_appearance", tableName: "Settings")
                    .font(MonarchUI.Font.sans(size: 18, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                Text("appearance.subtitle", tableName: "Settings")
                    .font(MonarchUI.Font.sans(size: 13))
                    .foregroundStyle(MonarchUI.Color.textSubtle)
            }
            
            HStack(spacing: 12) {
                // Dark Option Card
                DarkAppearanceCard(isSelected: settings.appearance == .dark) {
                    settings.appearance = .dark
                }
                
                // Light Option Card
                LightAppearanceCard(isSelected: settings.appearance == .light) {
                    settings.appearance = .light
                }
                
                // System Setting Option (Inline Text)
                Button {
                    settings.appearance = .system
                } label: {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("appearance.system_setting", tableName: "Settings")
                            .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                            .foregroundStyle(settings.appearance == .system ? MonarchUI.Color.accentViolet : MonarchUI.Color.textMuted)
                            .tracking(0.8)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("appearance.device_preference", tableName: "Settings")
                            .font(MonarchUI.Font.sans(size: 13))
                            .foregroundStyle(settings.appearance == .system ? MonarchUI.Color.textPrimary : MonarchUI.Color.textSecondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.leading, 8)
                    .frame(minHeight: 104, alignment: .center)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("System Setting appearance")
                .accessibilityHint("Use device system preference")
                .accessibilityAddTraits(settings.appearance == .system ? [.isButton, .isSelected] : [.isButton])
            }
        }
        .padding(.bottom, 26)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.divider)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

private struct DarkAppearanceCard: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 9) {
                // Visual Mockup Preview Box
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(MonarchUI.Color.accentViolet)
                        .frame(width: 24)
                    Rectangle()
                        .fill(MonarchUI.Color.divider)
                        .frame(width: 46)
                    Rectangle()
                        .fill(MonarchUI.Color.surface)
                }
                .padding(7)
                .frame(width: 162, height: 42)
                .background(MonarchUI.Color.cardDarkMockupBg)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.cardDarkMockupBorder, lineWidth: 1)
                )
                
                HStack {
                    Text("appearance.dark", tableName: "Settings")
                        .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    if isSelected {
                        Text("appearance.active", tableName: "Settings")
                            .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                            .foregroundStyle(MonarchUI.Color.accentViolet)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(11)
            .frame(width: 184)
            .frame(minHeight: 104)
            .background(isSelected ? MonarchUI.Color.cardDarkBg : MonarchUI.Color.cardLightBg)
            .overlay(
                Rectangle()
                    .stroke(isSelected ? MonarchUI.Color.accentViolet : MonarchUI.Color.fieldBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Dark appearance")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }
}

private struct LightAppearanceCard: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 9) {
                // Visual Mockup Preview Box
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(MonarchUI.Color.accentVioletBorder)
                        .frame(width: 24)
                    Rectangle()
                        .fill(MonarchUI.Color.cardLightMockupBorder)
                        .frame(width: 46)
                    Rectangle()
                        .fill(MonarchUI.Color.surface)
                }
                .padding(7)
                .frame(width: 162, height: 42)
                .background(MonarchUI.Color.cardLightMockupBg)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.cardLightMockupBorder, lineWidth: 1)
                )
                
                HStack {
                    Text("appearance.light", tableName: "Settings")
                        .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    if isSelected {
                        Text("appearance.active", tableName: "Settings")
                            .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                            .foregroundStyle(MonarchUI.Color.accentViolet)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(11)
            .frame(width: 184)
            .frame(minHeight: 104)
            .background(MonarchUI.Color.cardLightBg)
            .overlay(
                Rectangle()
                    .stroke(isSelected ? MonarchUI.Color.accentViolet : MonarchUI.Color.fieldBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Light appearance")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : [.isButton])
    }
}

#Preview {
    AppearancePanelView(settings: UserSettings())
        .padding()
        .background(MonarchUI.Color.background)
}
