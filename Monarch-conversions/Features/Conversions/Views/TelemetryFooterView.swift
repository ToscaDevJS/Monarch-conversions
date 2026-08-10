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
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                
                DividerBar()
                
                HStack(spacing: 6) {
                    Text("footer.throughput", tableName: "Common")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                    Text("14.2 MB/s")
                        .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                
                DividerBar()
                
                HStack(spacing: 6) {
                    Text("footer.avg_latency", tableName: "Common")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                    Text("120ms")
                        .font(MonarchUI.Font.sans(size: 12, weight: .semibold))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
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
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                        
                        Text("footer.export_telemetry", tableName: "Common")
                            .font(MonarchUI.Font.sans(size: 11, weight: .medium))
                            .foregroundStyle(MonarchUI.Color.textPrimary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Rectangle()
                            .fill(MonarchUI.Color.badgeGrayBg)
                    )
                    .overlay(
                        Rectangle()
                            .stroke(MonarchUI.Color.fieldBorder, lineWidth: 1)
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
    TelemetryFooterView()
        .background(MonarchUI.Color.background)
}
