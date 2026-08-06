import SwiftUI

struct AppearancePanelView: View {
    @Bindable var settings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Appearance")
                    .font(MonarchUI.Font.sans(size: 18, weight: .medium))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
                Text("Choose the color scheme for your workspace.")
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
                        Text("SYSTEM SETTING")
                            .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                            .foregroundStyle(settings.appearance == .system ? MonarchUI.Color.accentViolet : SwiftUI.Color(hex: "#838383"))
                            .tracking(0.8)
                        Text("Use device preference")
                            .font(MonarchUI.Font.sans(size: 13))
                            .foregroundStyle(settings.appearance == .system ? MonarchUI.Color.textPrimary : SwiftUI.Color(hex: "#C0C0C0"))
                    }
                    .padding(.leading, 8)
                    .frame(height: 104, alignment: .center)
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
                        .fill(SwiftUI.Color(hex: "#292929"))
                        .frame(width: 46)
                    Rectangle()
                        .fill(SwiftUI.Color(hex: "#171717"))
                }
                .padding(7)
                .frame(width: 162, height: 42)
                .background(MonarchUI.Color.cardDarkMockupBg)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.cardDarkMockupBorder, lineWidth: 1)
                )
                
                HStack {
                    Text("Dark")
                        .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    
                    Spacer()
                    
                    if isSelected {
                        Text("ACTIVE")
                            .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                            .foregroundStyle(MonarchUI.Color.accentViolet)
                    }
                }
            }
            .padding(11)
            .frame(width: 184, height: 104)
            .background(isSelected ? MonarchUI.Color.cardDarkBg : SwiftUI.Color(hex: "#111111"))
            .overlay(
                Rectangle()
                    .stroke(isSelected ? MonarchUI.Color.accentViolet : SwiftUI.Color(hex: "#3B3B3B"), lineWidth: 1)
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
                        .fill(SwiftUI.Color(hex: "#635B72"))
                        .frame(width: 24)
                    Rectangle()
                        .fill(SwiftUI.Color(hex: "#D8D8D5"))
                        .frame(width: 46)
                    Rectangle()
                        .fill(SwiftUI.Color.white)
                }
                .padding(7)
                .frame(width: 162, height: 42)
                .background(MonarchUI.Color.cardLightMockupBg)
                .overlay(
                    Rectangle()
                        .stroke(MonarchUI.Color.cardLightMockupBorder, lineWidth: 1)
                )
                
                HStack {
                    Text("Light")
                        .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                        .foregroundStyle(SwiftUI.Color(hex: "#D6D6D6"))
                    
                    Spacer()
                    
                    if isSelected {
                        Text("ACTIVE")
                            .font(MonarchUI.Font.mono(size: 11, weight: .regular))
                            .foregroundStyle(MonarchUI.Color.accentViolet)
                    }
                }
            }
            .padding(11)
            .frame(width: 184, height: 104)
            .background(SwiftUI.Color(hex: "#111111"))
            .overlay(
                Rectangle()
                    .stroke(isSelected ? MonarchUI.Color.accentViolet : SwiftUI.Color(hex: "#3B3B3B"), lineWidth: 1)
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
