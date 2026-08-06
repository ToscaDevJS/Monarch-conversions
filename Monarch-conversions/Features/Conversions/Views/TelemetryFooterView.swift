import SwiftUI

struct TelemetryFooterView: View {
    var body: some View {
        HStack(spacing: 0) {
            // Left telemetry stats
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(MonarchUI.Color.statusGreen)
                        .frame(width: 7, height: 7)
                        .shadow(color: MonarchUI.Color.statusGreen.opacity(0.4), radius: 3)
                    
                    Text("Node us-east-1a")
                        .font(MonarchUI.Font.sans(size: 12, weight: .medium))
                        .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                }
                
                DividerBar()
                
                HStack(spacing: 6) {
                    Text("Throughput:")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                    Text("14.2 MB/s")
                        .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                        .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                }
                
                DividerBar()
                
                HStack(spacing: 6) {
                    Text("Avg Latency:")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                    Text("120ms")
                        .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                        .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                }
            }
            
            Spacer()
            
            // Right telemetry actions
            HStack(spacing: 16) {
                Text("Active: 5 · Queued: 1")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textMuted)
                
                DividerBar()
                
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                        
                        Text("Export Telemetry Log")
                            .font(MonarchUI.Font.sans(size: 11, weight: .medium))
                            .foregroundStyle(SwiftUI.Color(hex: "#E4E4E2"))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Rectangle()
                            .fill(SwiftUI.Color(hex: "#252525"))
                    )
                    .overlay(
                        Rectangle()
                            .stroke(SwiftUI.Color(hex: "#333333"), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 48)
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
    TelemetryFooterView()
        .background(MonarchUI.Color.background)
}
