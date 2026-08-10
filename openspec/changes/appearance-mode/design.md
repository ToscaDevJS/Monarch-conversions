# Design: Adaptive Light and Dark Mode Appearance

## Architecture & Data Flow

```
[UserSettings.appearance] (.dark | .light | .system)
       │
       ▼
[.preferredColorScheme()] in RootView.swift
       │
       ▼
[SwiftUI Environment (\.colorScheme)]
       │
       ▼
[MonarchUI.Color Dynamic Tokens] ──(Light/Dark NSColor Provider)──► Renders Light or Dark UI
```

## Dynamic Color Tokens Architecture
We extend `SwiftUI.Color` with a cross-platform/macOS helper:
```swift
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
}
```

### Color Token Palette Mapping

| Token Name | Dark Hex | Light Hex | Purpose |
|------------|----------|-----------|---------|
| `background` | `#090909` | `#F8F9FA` | Main workspace background |
| `surface` | `#171717` | `#FFFFFF` | Card & container surfaces |
| `surfaceBorder` | `#242424` | `#E2E8F0` | Container borders |
| `divider` | `#292929` | `#E2E8F0` | Section separators |
| `textPrimary` | `#F4F4F2` | `#0F172A` | Main headings & primary text |
| `textSecondary` | `#A0A0A0` | `#475569` | Body text & labels |
| `textSubtle` | `#9B9B9B` | `#64748B` | Subtitles & helper text |
| `textMuted` | `#888888` | `#94A3B8` | Captions & inactive text |
| `accentViolet` | `#A78BFA` | `#7C3AED` | Primary brand accent |
| `accentVioletBg` | `#17121F` | `#F5F3FF` | Active row / selection highlight |
| `accentVioletBorder`| `#3F305C` | `#DDD6FE` | Active element borders |
| `fieldBorder` | `#3B3B3B` | `#CBD5E1` | Input fields & select borders |
| `searchBg` | `#171717` | `#F1F5F9` | Search inputs & dropzones |

## Verification Plan
1. `xcodebuild test` unit test suite confirming color scheme resolution in `UserSettingsTests` and `MonarchUITests`.
2. Clean compilation across all macOS targets with zero warnings.
