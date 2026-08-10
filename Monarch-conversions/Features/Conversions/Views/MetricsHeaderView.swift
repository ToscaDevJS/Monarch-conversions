import SwiftUI

struct MetricsHeaderView: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            // Images processed
            VStack(alignment: .leading, spacing: 5) {
                Text("metrics.processed", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
                
                HStack(spacing: 16) {
                    Text("28,492")
                        .font(MonarchUI.Font.mono(size: 21, weight: .regular))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    
                    SparklineView()
                        .frame(width: 250, height: 26)
                }
            }
            .frame(width: 440, alignment: .leading)
            
            DividerLine()
            
            // In queue (24h)
            VStack(alignment: .leading, spacing: 5) {
                Text("metrics.in_queue", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
                
                HStack {
                    Text("12")
                        .font(MonarchUI.Font.mono(size: 21, weight: .regular))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    
                    Spacer()
                    
                    Text("▁▃▅▇")
                        .font(MonarchUI.Font.sans(size: 17))
                        .tracking(1.7)
                        .foregroundStyle(MonarchUI.Color.textDim)
                }
                .frame(width: 200)
            }
            .padding(.leading, 20)
            .frame(width: 220, alignment: .leading)
            
            DividerLine()
            
            // Converted today
            VStack(alignment: .leading, spacing: 5) {
                Text("metrics.converted_today", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
                
                HStack {
                    Text("1,574")
                        .font(MonarchUI.Font.mono(size: 21, weight: .regular))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    
                    Spacer()
                    
                    Text("▁▃▆▇")
                        .font(MonarchUI.Font.sans(size: 17))
                        .tracking(1.7)
                        .foregroundStyle(MonarchUI.Color.textDim)
                }
                .frame(width: 200)
            }
            .padding(.leading, 20)
            .frame(width: 220, alignment: .leading)
            
            DividerLine()
            
            // Storage saved
            VStack(alignment: .leading, spacing: 5) {
                Text("metrics.storage_saved", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
                
                Text("748 GB")
                    .font(MonarchUI.Font.mono(size: 21, weight: .regular))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .padding(.leading, 20)
            .frame(width: 220, alignment: .leading)
            
            DividerLine()
            
            // Active projects
            VStack(alignment: .leading, spacing: 5) {
                Text("metrics.active_projects", tableName: "Conversions")
                    .font(MonarchUI.Font.sans(size: 12))
                    .foregroundStyle(MonarchUI.Color.textSecondary)
                
                Text("174")
                    .font(MonarchUI.Font.mono(size: 21, weight: .regular))
                    .foregroundStyle(MonarchUI.Color.textPrimary)
            }
            .padding(.leading, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 12)
        .padding(.top, 42)
        .overlay(
            Rectangle()
                .fill(MonarchUI.Color.divider)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

private struct DividerLine: View {
    var body: some View {
        Rectangle()
            .fill(MonarchUI.Color.divider)
            .frame(width: 1, height: 50)
    }
}

private struct SparklineView: View {
    var body: some View {
        Canvas { context, size in
            var path = Path()
            let points: [CGPoint] = [
                CGPoint(x: 1, y: 5), CGPoint(x: 13, y: 2), CGPoint(x: 25, y: 20),
                CGPoint(x: 37, y: 18), CGPoint(x: 45, y: 17), CGPoint(x: 53, y: 7),
                CGPoint(x: 61, y: 10), CGPoint(x: 67, y: 18), CGPoint(x: 75, y: 18),
                CGPoint(x: 84, y: 9), CGPoint(x: 91, y: 9), CGPoint(x: 97, y: 16),
                CGPoint(x: 110, y: 16), CGPoint(x: 119, y: 2), CGPoint(x: 127, y: 2),
                CGPoint(x: 133, y: 14), CGPoint(x: 149, y: 14), CGPoint(x: 157, y: 14),
                CGPoint(x: 163, y: 6), CGPoint(x: 178, y: 6), CGPoint(x: 186, y: 7),
                CGPoint(x: 194, y: 16), CGPoint(x: 210, y: 15), CGPoint(x: 221, y: 16),
                CGPoint(x: 231, y: 26), CGPoint(x: 243, y: 22), CGPoint(x: 250, y: 14)
            ]
            if let first = points.first {
                path.move(to: first)
                for pt in points.dropFirst() {
                    path.addLine(to: pt)
                }
            }
            context.stroke(path, with: .color(MonarchUI.Color.textSecondary), lineWidth: 1)
        }
    }
}

#Preview {
    MetricsHeaderView()
        .padding()
        .background(MonarchUI.Color.background)
}
