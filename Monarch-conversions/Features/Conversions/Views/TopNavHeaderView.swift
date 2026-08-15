import SwiftUI

struct TopNavHeaderView: View {
    var activeTab: AppTab = .studio
    var onSelectTab: ((AppTab) -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            // Logo section
            Button {
                onSelectTab?(.studio)
            } label: {
                HStack(spacing: 9) {
                    GridIcon()
                        .frame(width: 27, height: 27)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Monarch")
                            .font(MonarchUI.Font.mono(size: 14, weight: .semibold))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        Text("image tools")
                            .font(MonarchUI.Font.mono(size: 10))
                            .foregroundStyle(MonarchUI.Color.textMuted)
                    }
                }
            }
            .buttonStyle(.plain)
            .frame(width: 162, alignment: .leading)
            
            // Nav Links
            HStack(spacing: 28) {
                NavItem(
                    title: String(localized: "nav.studio", table: "Common"),
                    isActive: activeTab == .studio,
                    hasDropdown: true,
                    accessibilityIdentifier: "nav-studio"
                ) {
                    onSelectTab?(.studio)
                }
                NavItem(
                    title: String(localized: "nav.convert", table: "Common"),
                    isActive: activeTab == .convert,
                    accessibilityIdentifier: "nav-convert"
                ) {
                    onSelectTab?(.convert)
                }
                NavItem(
                    title: String(localized: "nav.settings", table: "Common"),
                    isActive: activeTab == .settings,
                    accessibilityIdentifier: "nav-settings"
                ) {
                    onSelectTab?(.settings)
                }
            }
            .frame(height: 32)
            
            Spacer()
            
            // Status badge
            HStack(spacing: 8) {
                Rectangle()
                    .fill(MonarchUI.Color.accentViolet)
                    .frame(width: 6, height: 6)
                
                Text(activeTab == .settings ? String(localized: "badge.settings", table: "Common") : String(localized: "badge.conversions", table: "Common"))
                    .font(MonarchUI.Font.mono(size: 11, weight: .semibold))
                    .foregroundStyle(MonarchUI.Color.accentViolet)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(MonarchUI.Color.accentVioletBg)
            .overlay(
                Rectangle()
                    .stroke(MonarchUI.Color.accentVioletBorder, lineWidth: 1)
            )
        }
        .padding(.bottom, 18)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.surfaceBorder)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

private struct NavItem: View {
    let title: String
    var isActive: Bool = false
    var hasDropdown: Bool = false
    let accessibilityIdentifier: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if title == String(localized: "nav.studio", table: "Common") || title == "STUDIO" {
                    Image(systemName: "sun.max")
                        .font(.system(size: 10))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
                
                Text(title)
                    .font(MonarchUI.Font.mono(size: 12, weight: isActive ? .semibold : .regular))
                    .foregroundStyle(isActive ? MonarchUI.Color.textPrimary : MonarchUI.Color.textMuted)
                
                if hasDropdown {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
            }
            .frame(height: 32)
            .overlay(
                Rectangle()
                    .fill(isActive ? MonarchUI.Color.accentViolet : SwiftUI.Color.clear)
                    .frame(height: 2),
                alignment: .bottom
            )
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

private struct GridIcon: View {
    var body: some View {
        Canvas { context, size in
            let itemSize: CGFloat = 5
            let gap: CGFloat = 4
            for row in 0..<3 {
                for col in 0..<3 {
                    let rect = CGRect(
                        x: CGFloat(col) * (itemSize + gap) + 2,
                        y: CGFloat(row) * (itemSize + gap) + 2,
                        width: itemSize,
                        height: itemSize
                    )
                    context.fill(Path(rect), with: .color(MonarchUI.Color.textPrimary))
                }
            }
        }
    }
}

#Preview {
    TopNavHeaderView(activeTab: .studio)
        .padding()
        .background(MonarchUI.Color.background)
}
