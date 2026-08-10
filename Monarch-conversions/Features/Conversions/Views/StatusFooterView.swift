import SwiftUI

struct StatusFooterView: View {
    var body: some View {
        HStack(spacing: 0) {
            // Left Content
            HStack(spacing: 14) {
                // File Info
                HStack(spacing: 8) {
                    Text("PNG")
                        .font(MonarchUI.Font.sans(size: 11, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Rectangle()
                                .fill(MonarchUI.Color.badgeGrayBg)
                        )
                        .overlay(
                            Rectangle()
                                .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
                        )
                    
                    Text("1 archivo")
                        .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    
                    Text("·")
                        .foregroundStyle(MonarchUI.Color.textMuted)
                    
                    Text("165 kB")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                }
                
                DividerBar()
                
                // Quality Info
                HStack(spacing: 6) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                    
                    Text("footer.quality 85%", tableName: "Common")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                
                DividerBar()
                
                // Location Pill
                HStack(spacing: 6) {
                    Image(systemName: "folder")
                        .font(.system(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                    
                    Text("Descargas/Luminary")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
            }
            
            Spacer()
            
            // Right Content
            HStack(spacing: 14) {
                // Status Badge
                HStack(spacing: 6) {
                    Circle()
                        .fill(MonarchUI.Color.statusGreen)
                        .frame(width: 7, height: 7)
                    
                    Text("footer.synced", tableName: "Common")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                
                DividerBar()
                
                // Controls
                HStack(spacing: 12) {
                    Text("100%")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 13))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(MonarchUI.Color.searchBg)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.divider)
                .frame(height: 1),
            alignment: .top
        )
    }
}

private struct DividerBar: View {
    var body: some View {
        Rectangle()
            .fill(MonarchUI.Color.divider)
            .frame(width: 1, height: 16)
    }
}

#Preview {
    StatusFooterView()
        .background(MonarchUI.Color.background)
}
