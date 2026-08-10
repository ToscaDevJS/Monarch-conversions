# Spec: Adaptive Light and Dark Mode Appearance

## Requirements

### Requirement AM-1: Dynamic Color Tokens
`MonarchUI.Color` tokens MUST dynamically adapt to the active SwiftUI `ColorScheme` (Light or Dark), providing dedicated light and dark hex definitions for all surface, text, border, and accent colors.

### Requirement AM-2: View & Component Migration
All feature views across Studio, Conversions, Settings, Headers, Footers, Modals, and Cards MUST use `MonarchUI.Color` tokens instead of hardcoded inline HEX or static color values.

### Requirement AM-3: Seamless Settings Preference Switching
Toggling between `Dark`, `Light`, and `System Setting` in the Appearance Settings panel MUST reactively update the entire app UI immediately without requiring an application restart.

### Requirement AM-4: Automated Verification
The test suite MUST verify `UserSettings.preferredColorScheme` mapping for `.dark`, `.light`, and `.system`, and ensure `MonarchUI.Color` initializes dynamic colors without runtime crashes.

## Scenarios

### Scenario 1: User Selects Light Mode
- **Given** the app is in Dark mode
- **When** the user selects "Light" in Appearance settings
- **Then** `UserSettings.appearance` becomes `.light`, `preferredColorScheme` returns `.light`, and all `MonarchUI.Color` tokens render their light variant.

### Scenario 2: User Selects Dark Mode
- **Given** the app is in Light mode
- **When** the user selects "Dark" in Appearance settings
- **Then** `UserSettings.appearance` becomes `.dark`, `preferredColorScheme` returns `.dark`, and all `MonarchUI.Color` tokens render their dark variant.

### Scenario 3: User Selects System Preference
- **Given** the user selects "System Setting" in Appearance settings
- **When** system appearance changes between Light and Dark
- **Then** `UserSettings.appearance` returns `.system`, `preferredColorScheme` returns `nil`, and `MonarchUI.Color` tokens automatically match the system color scheme.
