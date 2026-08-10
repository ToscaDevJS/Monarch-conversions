import SwiftUI

enum MonarchUI {
    enum Color {
        static let background = SwiftUI.Color(lightHex: "#F8F9FA", darkHex: "#090909")
        static let surface = SwiftUI.Color(lightHex: "#FFFFFF", darkHex: "#171717")
        static let surfaceBorder = SwiftUI.Color(lightHex: "#E2E8F0", darkHex: "#242424")
        static let divider = SwiftUI.Color(lightHex: "#E2E8F0", darkHex: "#292929")
        
        static let textPrimary = SwiftUI.Color(lightHex: "#0F172A", darkHex: "#F4F4F2")
        static let textSecondary = SwiftUI.Color(lightHex: "#475569", darkHex: "#A0A0A0")
        static let textSubtle = SwiftUI.Color(lightHex: "#64748B", darkHex: "#9B9B9B")
        static let textMuted = SwiftUI.Color(lightHex: "#94A3B8", darkHex: "#888888")
        static let textDim = SwiftUI.Color(lightHex: "#CBD5E1", darkHex: "#777777")
        
        static let accentViolet = SwiftUI.Color(lightHex: "#7C3AED", darkHex: "#A78BFA")
        static let accentVioletBg = SwiftUI.Color(lightHex: "#F5F3FF", darkHex: "#17121F")
        static let accentVioletBorder = SwiftUI.Color(lightHex: "#DDD6FE", darkHex: "#3F305C")
        
        static let sidebarActiveBg = SwiftUI.Color(lightHex: "#F1F5F9", darkHex: "#1B1821")
        static let cardDarkBg = SwiftUI.Color(lightHex: "#F8F9FA", darkHex: "#17131D")
        static let cardLightBg = SwiftUI.Color(lightHex: "#FFFFFF", darkHex: "#111111")
        static let cardDarkMockupBg = SwiftUI.Color(lightHex: "#1E293B", darkHex: "#0B0B0B")
        static let cardDarkMockupBorder = SwiftUI.Color(lightHex: "#334155", darkHex: "#36313D")
        static let cardLightMockupBg = SwiftUI.Color(lightHex: "#F1F5F9", darkHex: "#F4F4F2")
        static let cardLightMockupBorder = SwiftUI.Color(lightHex: "#CBD5E1", darkHex: "#D8D8D5")
        static let fieldBorder = SwiftUI.Color(lightHex: "#CBD5E1", darkHex: "#3B3B3B")
        
        static let statusGreen = SwiftUI.Color(lightHex: "#16A34A", darkHex: "#78C86B")
        static let statusGreenGlow = SwiftUI.Color(lightHex: "#DCFCE7", darkHex: "#163414")
        
        static let rowWorkingBg = SwiftUI.Color(lightHex: "#E2E8F0", darkHex: "#2B2B2B")
        static let rowAlternateBg = SwiftUI.Color(lightHex: "#F8F9FA", darkHex: "#1A1A1A")
        static let rowEvenBg = SwiftUI.Color(lightHex: "#FFFFFF", darkHex: "#202020")
        
        static let pillDoneBg = SwiftUI.Color(lightHex: "#E2E8F0", darkHex: "#F2F2F0")
        static let pillDoneText = SwiftUI.Color(lightHex: "#0F172A", darkHex: "#232323")
        
        static let badgeGrayBg = SwiftUI.Color(lightHex: "#E2E8F0", darkHex: "#414141")
        static let searchBg = SwiftUI.Color(lightHex: "#F1F5F9", darkHex: "#171717")
        static let shortcutBg = SwiftUI.Color(lightHex: "#E2E8F0", darkHex: "#303030")
    }

    enum Font {
        static func mono(size: CGFloat, weight: SwiftUI.Font.Weight = .regular) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .monospaced)
        }
        
        static func sans(size: CGFloat, weight: SwiftUI.Font.Weight = .regular) -> SwiftUI.Font {
            .system(size: size, weight: weight, design: .default)
        }
    }
}

extension SwiftUI.Color {
    init(light: SwiftUI.Color, dark: SwiftUI.Color) {
        #if os(macOS)
        self.init(nsColor: NSColor(name: nil, dynamicProvider: { appearance in
            appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
                ? NSColor(dark)
                : NSColor(light)
        }))
        #else
        self.init(light: light, dark: dark)
        #endif
    }
    
    init(lightHex: String, darkHex: String) {
        self.init(light: SwiftUI.Color(hex: lightHex), dark: SwiftUI.Color(hex: darkHex))
    }

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
