# Proposal: Appearance Preference (Dark, Light, System)

## Context
Monarch currently supports appearance options in `UserSettings` (`.dark`, `.light`, `.system`), rendered via `AppearancePanelView`. However, user selection needs to be properly persisted and dynamically synced with the app environment color scheme and system preferences.

## Proposed Changes
1. **State & Persistence**: Store user preference in `UserSettings` using `@AppStorage` / `UserDefaults` to retain choices across app restarts.
2. **Color Scheme Integration**: Bind selected appearance option (`.dark`, `.light`, `.system`) to the root window / view color scheme override.
3. **UI Feedback & Accessibility**: Improve `AppearancePanelView` card interactions and accessibility labels for Dark, Light, and System cards.

## Impact
- `UserSettings.swift`: Add persistence mechanism for `AppearanceOption`.
- `AppearancePanelView.swift`: Wire appearance selection to active settings and improve accessibility.
- `MonarchApp.swift` / Root View: Apply `.preferredColorScheme()` based on `userSettings.appearance`.
