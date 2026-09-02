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
        static let statusRed = SwiftUI.Color(lightHex: "#DC2626", darkHex: "#EF4444")
        
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

    /// Shared geometry consumed by more than one view.
    ///
    /// Values that only one view cares about stay at their call site; anything two
    /// places must agree on — a window floor, a column width, a scene inset — lives
    /// here so the two sides cannot drift.
    enum Layout {
        /// Derived from the per-surface arithmetic in `Layout.Settings.requiredWidth`
        /// and its siblings, not from the original design mockup: every surface must
        /// fit inside this width in English and in Spanish.
        static let minWindowWidth: CGFloat = 1180
        static let minWindowHeight: CGFloat = 600

        /// The inset every scene applies around its content.
        static let scenePadding: CGFloat = 28

        /// Widths the Settings surface is built from.
        enum Settings {
            static let sidebarWidth: CGFloat = 230
            static let detailLeadingPadding: CGFloat = 42
            static let detailMaxWidth: CGFloat = 770

            /// Horizontal room the Settings content needs, excluding `scenePadding`.
            static var requiredWidth: CGFloat {
                sidebarWidth + detailLeadingPadding + detailMaxWidth
            }
        }

        /// Column geometry and horizontal scroll requirements for the Conversions table.
        enum TableColumn {
            static let status: CGFloat = 137
            static let fileID: CGFloat = 115
            static let fileName: CGFloat = 274
            static let dimensions: CGFloat = 235
            static let output: CGFloat = 274
            static let project: CGFloat = 170
            static let addedMinWidth: CGFloat = 120
            static let horizontalPadding: CGFloat = 12

            /// The six fixed-width columns that cannot shrink.
            static var fixedTotal: CGFloat {
                status + fileID + fileName + dimensions + output + project
            }

            /// Total horizontal content width carried by the horizontal scroll view.
            static var contentWidth: CGFloat {
                fixedTotal + addedMinWidth + horizontalPadding * 2
            }
        }

        /// Column and card geometry for the Convert surface.
        enum Convert {
            static let leftColumnMin: CGFloat = 380
            static let leftColumnIdeal: CGFloat = 460
            static let leftColumnMax: CGFloat = 520
            static let columnGap: CGFloat = 24
            static let settingBoxSpacing: CGFloat = 10
            static let formatBoxWidth: CGFloat = 180
            static let qualityBoxWidth: CGFloat = 180
            static let dimensionsBoxWidth: CGFloat = 230
            static let metadataBoxWidth: CGFloat = 170
            static let outputSettingsHorizontalPadding: CGFloat = 18

            /// Inner width required by the 3-box compact top row (Format, Quality, Metadata + gaps).
            static var outputSettingsCompactContentWidth: CGFloat {
                formatBoxWidth + qualityBoxWidth + metadataBoxWidth + settingBoxSpacing * 2
            }

            /// Horizontal room the compact output settings card needs, including its own padding.
            static var compactSettingsWidth: CGFloat {
                outputSettingsCompactContentWidth + outputSettingsHorizontalPadding * 2
            }
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
