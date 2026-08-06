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
                        .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Rectangle()
                                .fill(SwiftUI.Color(hex: "#252525"))
                        )
                        .overlay(
                            Rectangle()
                                .stroke(SwiftUI.Color(hex: "#333333"), lineWidth: 1)
                        )
                    
                    Text("1 archivo")
                        .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                        .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                    
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
                    
                    Text("Calidad 85%")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                }
                
                DividerBar()
                
                // Location Pill
                HStack(spacing: 6) {
                    Image(systemName: "folder")
                        .font(.system(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                    
                    Text("Descargas/Luminary")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
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
                    
                    Text("Sincronizado")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                }
                
                DividerBar()
                
                // Controls
                HStack(spacing: 12) {
                    Text("100%")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 13))
                            .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
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
                .fill(SwiftUI.Color(hex: "#282828"))
                .frame(height: 1),
            alignment: .top
        )
    }
}

private struct DividerBar: View {
    var body: some View {
        Rectangle()
            .fill(SwiftUI.Color(hex: "#2D2D2D"))
            .frame(width: 1, height: 16)
    }
}

#Preview {
    StatusFooterView()
        .background(MonarchUI.Color.background)
}
