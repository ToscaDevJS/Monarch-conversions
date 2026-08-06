import SwiftUI

enum MonarchUI {
    enum Color {
        static let background = SwiftUI.Color(hex: "#090909")
        static let surface = SwiftUI.Color(hex: "#171717")
        static let surfaceBorder = SwiftUI.Color(hex: "#242424")
        static let divider = SwiftUI.Color(hex: "#292929")
        
        static let textPrimary = SwiftUI.Color(hex: "#F4F4F2")
        static let textSecondary = SwiftUI.Color(hex: "#A0A0A0")
        static let textSubtle = SwiftUI.Color(hex: "#9B9B9B")
        static let textMuted = SwiftUI.Color(hex: "#888888")
        static let textDim = SwiftUI.Color(hex: "#777777")
        
        static let accentViolet = SwiftUI.Color(hex: "#A78BFA")
        static let accentVioletBg = SwiftUI.Color(hex: "#17121F")
        static let accentVioletBorder = SwiftUI.Color(hex: "#3F305C")
        
        static let sidebarActiveBg = SwiftUI.Color(hex: "#1B1821")
        static let cardDarkBg = SwiftUI.Color(hex: "#17131D")
        static let cardLightBg = SwiftUI.Color(hex: "#111111")
        static let cardDarkMockupBg = SwiftUI.Color(hex: "#0B0B0B")
        static let cardDarkMockupBorder = SwiftUI.Color(hex: "#36313D")
        static let cardLightMockupBg = SwiftUI.Color(hex: "#F4F4F2")
        static let cardLightMockupBorder = SwiftUI.Color(hex: "#D8D8D5")
        static let fieldBorder = SwiftUI.Color(hex: "#3B3B3B")
        
        static let statusGreen = SwiftUI.Color(hex: "#78C86B")
        static let statusGreenGlow = SwiftUI.Color(hex: "#163414")
        
        static let rowWorkingBg = SwiftUI.Color(hex: "#2B2B2B")
        static let rowAlternateBg = SwiftUI.Color(hex: "#1A1A1A")
        static let rowEvenBg = SwiftUI.Color(hex: "#202020")
        
        static let pillDoneBg = SwiftUI.Color(hex: "#F2F2F0")
        static let pillDoneText = SwiftUI.Color(hex: "#232323")
        
        static let badgeGrayBg = SwiftUI.Color(hex: "#414141")
        static let searchBg = SwiftUI.Color(hex: "#171717")
        static let shortcutBg = SwiftUI.Color(hex: "#303030")
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
