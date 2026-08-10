# Proposal: Adaptive Light and Dark Mode Appearance

## Problem
While `UserSettings` allows selecting `Dark`, `Light`, or `System Setting` appearance options and applies `.preferredColorScheme(userSettings.preferredColorScheme)`, the design tokens in `MonarchUI.Color` are currently hardcoded dark HEX values (`#090909`, `#171717`, `#F4F4F2`, etc.). Switching to Light mode causes macOS native controls to turn light while custom views remain dark, creating an inconsistent and broken visual experience.

## Proposed Solution
1. **Dynamic Design Tokens**: Refactor `MonarchUI.Color` to use adaptive dynamic colors (`NSColor(name: dynamicProvider:)` or Light/Dark adaptive initializers) so design system tokens automatically map to high-contrast, premium Light and Dark palettes based on the active color scheme.
2. **Semantic View Migration**: Replace hardcoded inline HEX colors (`#404040`, `#292929`, `Color.white`, etc.) across feature views (Conversions, Settings, Modals, Navigation, Footers) with semantic `MonarchUI.Color` tokens.
3. **Unit Tests**: Add unit tests verifying `MonarchUI.Color` dynamic resolution and `UserSettings` color scheme mapping in both light and dark modes.

## Impact
All application views and components will seamlessly adapt to Dark Mode, Light Mode, and System Preferences, maintaining the Paper design system aesthetic in both modes.
