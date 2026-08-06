# Proposal: Language Preference Setting

## Intent
Enable user selection of display language (`English` vs `Español`) in `SettingsScene` via `LanguagePanelView`, persisting the selection in `UserDefaults` and propagating locale updates to the SwiftUI view hierarchy.

## Scope
- Add `AppLanguage` enum (`.english`, `.spanish`) in `UserSettings.swift`.
- Back `language` property with `UserDefaults.standard` persistence.
- Provide `locale` computed property on `AppLanguage` (`Locale(identifier: "en")`, `Locale(identifier: "es")`).
- Replace hardcoded string display in `LanguagePanelView` with an interactive `Picker` / `Menu` control with VoiceOver accessibility labels and hints.
- Apply `.environment(\.locale, userSettings.language.locale)` at `RootView` level.
- Add strict unit tests for default value, persistence, and locale mapping in `UserSettingsTests.swift`.

## Approach
- Follow modern `@Observable` pattern in `UserSettings.swift` with `@ObservationIgnored` key `monarch.userSettings.language`.
- Extend `LanguagePanelView` with accessible UI selection.
- Validate via Strict TDD with `xcodebuild` test suite execution.
