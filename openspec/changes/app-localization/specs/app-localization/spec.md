# Specification: App Localization

## Requirements

### AL-1: String Catalog Definition
The application MUST include `Localizable.xcstrings` configured with English (`en`) as development language and Spanish (`es`) as secondary language.

### AL-2: Environment Locale Propagation
`RootView` MUST observe `UserSettings.language` and inject `.environment(\.locale, userSettings.language.locale)` down the view hierarchy so all SwiftUI components react to language switches immediately without requiring an application restart.

### AL-3: Full View Hierarchy Localization
ALL user-visible text in `Scenes/` and `Features/` views MUST resolve through the String Catalog rather than hardcoded string literals.

### AL-4: Format & Metric Formatting Consistency
Number, byte size, date, and percentage formatting (`ConversionFormatting`) MUST adapt to the active `Locale` where appropriate (e.g. decimal separators and localized unit symbols).

### AL-5: Test Verification
The test suite MUST contain unit tests in `Monarch-conversionsTests` verifying that `AppLanguage.locale` resolves to `"en"` and `"es"` and that string keys exist and resolve properly.
