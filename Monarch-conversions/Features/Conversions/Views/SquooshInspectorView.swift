import SwiftUI

struct SquooshInspectorView: View {
    let fileName: String
    let originalSizeText: String
    let targetFormatText: String
    let targetSizeText: String
    @State private var sliderOffset: CGFloat = 0.5
    
    var body: some View {
        VStack(spacing: 0) {
            // Inspector Header
            HStack {
                HStack(spacing: 10) {
                    Text(fileName)
                        .font(MonarchUI.Font.sans(size: 13, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                    
                    Text("inspector.comparison", tableName: "Conversions")
                        .font(MonarchUI.Font.sans(size: 14, weight: .medium))
                        .foregroundStyle(MonarchUI.Color.textPrimary)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Text("inspector.mode", tableName: "Conversions")
                        .font(MonarchUI.Font.sans(size: 12))
                        .foregroundStyle(MonarchUI.Color.textMuted)
                    
                    Text("inspector.zoom", tableName: "Conversions")
                        .font(MonarchUI.Font.mono(size: 11))
                        .foregroundStyle(SwiftUI.Color(hex: "#8F8F8F"))
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 40)
            .background(SwiftUI.Color(hex: "#171717"))
            .overlay(
                Rectangle()
                    .fill(SwiftUI.Color(hex: "#242424"))
                    .frame(height: 1),
                alignment: .bottom
            )
            
            // Visual Split Comparison View
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let splitX = width * sliderOffset
                
                ZStack(alignment: .leading) {
                    // Right Side (Optimized Image)
                    ZStack {
                        SwiftUI.Color(hex: "#0C0B10")
                        
                        VStack {
                            Text("WEBP OPTIMIZED")
                                .font(MonarchUI.Font.mono(size: 14, weight: .semibold))
                                .foregroundStyle(MonarchUI.Color.accentViolet)
                                .frame(width: 320, height: 170)
                                .background(
                                    LinearGradient(
                                        colors: [SwiftUI.Color(hex: "#1B1229"), SwiftUI.Color(hex: "#2B1B47")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                        }
                        
                        VStack {
                            HStack {
                                Spacer()
                                Text(targetSizeText)
                                    .font(MonarchUI.Font.mono(size: 11, weight: .semibold))
                                    .foregroundStyle(MonarchUI.Color.accentViolet)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(MonarchUI.Color.accentVioletBg)
                                    .overlay(
                                        Rectangle()
                                            .stroke(MonarchUI.Color.accentVioletBorder, lineWidth: 1)
                                    )
                            }
                            Spacer()
                        }
                        .padding(12)
                    }
                    .frame(width: width, height: height)
                    
                    // Left Side (Original Image clipped by splitX)
                    ZStack(alignment: .topLeading) {
                        ZStack {
                            SwiftUI.Color(hex: "#14121A")
                            
                            VStack {
                                Text("ORIGINAL (PNG)")
                                    .font(MonarchUI.Font.mono(size: 14, weight: .semibold))
                                    .foregroundStyle(SwiftUI.Color(hex: "#E2D9F7"))
                                    .frame(width: 320, height: 170)
                                    .background(
                                        LinearGradient(
                                            colors: [SwiftUI.Color(hex: "#242030"), SwiftUI.Color(hex: "#342C44")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 3))
                            }
                            
                            VStack {
                                HStack {
                                    Text(originalSizeText)
                                        .font(MonarchUI.Font.mono(size: 11))
                                        .foregroundStyle(MonarchUI.Color.textPrimary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(MonarchUI.Color.background)
                                        .overlay(
                                            Rectangle()
                                                .stroke(MonarchUI.Color.divider, lineWidth: 1)
                                        )
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding(12)
                        }
                        .frame(width: width, height: height)
                    }
                    .frame(width: max(0, splitX), height: height, alignment: .leading)
                    .clipped()
                    
                    // Split Divider Handle Line
                    Rectangle()
                        .fill(MonarchUI.Color.accentViolet)
                        .frame(width: 2)
                        .offset(x: splitX - 1)
                    
                    // Circular Handle Button
                    ZStack {
                        Circle()
                            .fill(MonarchUI.Color.accentViolet)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Circle()
                                    .stroke(MonarchUI.Color.textPrimary, lineWidth: 2)
                            )
                        Text("⬌")
                            .font(MonarchUI.Font.sans(size: 10, weight: .bold))
                            .foregroundStyle(MonarchUI.Color.accentVioletBg)
                    }
                    .position(x: splitX, y: height / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let newOffset = gesture.location.x / width
                                sliderOffset = min(max(newOffset, 0.05), 0.95)
                            }
                    )
                }
            }
            .frame(height: 280)
            .background(SwiftUI.Color(hex: "#050505"))
        }
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .background(SwiftUI.Color(hex: "#101010"))
        .overlay(
            RoundedRectangle(cornerRadius: 2)
                .stroke(SwiftUI.Color(hex: "#303030"), lineWidth: 1)
        )
    }
}

#Preview {
    SquooshInspectorView(
        fileName: "hero-banner.png",
        originalSizeText: "ORIGINAL: 2.8 MB",
        targetFormatText: "WEBP OPTIMIZED",
        targetSizeText: "WEBP: 420 KB (-85%)"
    )
    .padding()
    .background(MonarchUI.Color.background)
}
