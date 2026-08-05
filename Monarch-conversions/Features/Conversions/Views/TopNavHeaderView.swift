import SwiftUI

struct TopNavHeaderView: View {
    @State private var activeTab: String = "STUDIO"
    
    var body: some View {
        HStack(spacing: 0) {
            // Logo section
            HStack(spacing: 9) {
                // Grid Icon
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
            .frame(width: 162, alignment: .leading)
            
            // Nav Links
            HStack(spacing: 28) {
                NavItem(title: "STUDIO", isActive: activeTab == "STUDIO", hasDropdown: true) {
                    activeTab = "STUDIO"
                }
                NavItem(title: "CONVERT", isActive: activeTab == "CONVERT") {
                    activeTab = "CONVERT"
                }
                NavItem(title: "COMPRESS", isActive: activeTab == "COMPRESS", hasDropdown: true) {
                    activeTab = "COMPRESS"
                }
                NavItem(title: "HISTORY", isActive: activeTab == "HISTORY", hasDropdown: true) {
                    activeTab = "HISTORY"
                }
                NavItem(title: "SETTINGS", isActive: activeTab == "SETTINGS") {
                    activeTab = "SETTINGS"
                }
            }
            .frame(height: 32)
            
            Spacer()
            
            // Conversions status badge
            HStack(spacing: 8) {
                Rectangle()
                    .fill(MonarchUI.Color.accentViolet)
                    .frame(width: 6, height: 6)
                
                Text("CONVERSIONS")
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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if isActive {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(MonarchUI.Color.accentViolet)
                }
                
                Text(title)
                    .font(MonarchUI.Font.mono(size: 12, weight: isActive ? .semibold : .regular))
                    .foregroundStyle(isActive ? MonarchUI.Color.textPrimary : MonarchUI.Color.textMuted)
                
                if hasDropdown {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(isActive ? MonarchUI.Color.accentViolet : MonarchUI.Color.textMuted)
                }
            }
            .padding(.bottom, isActive ? 2 : 0)
            .overlay(
                Rectangle()
                    .fill(isActive ? MonarchUI.Color.accentViolet : SwiftUI.Color.clear)
                    .frame(height: 2),
                alignment: .bottom
            )
        }
        .buttonStyle(.plain)
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
    TopNavHeaderView()
        .padding()
        .background(MonarchUI.Color.background)
}
