# Proposal: App Localization (English & Spanish)

## Intent
Enable full application localization in English (`en`) and Spanish (`es`). When the user updates the display language setting in `SettingsScene` via `LanguagePanelView`, all views across the application (Top Bar, Dashboard, Convert Scene, Settings, Inspector, Footers, and Modals) must reactively update their visible text to match the selected locale.

## Scope
- Create standard Apple String Catalog (`Localizable.xcstrings`) covering all user-visible strings across all scenes and components.
- Ensure `RootView` injects `.environment(\.locale, userSettings.language.locale)` down the entire SwiftUI view hierarchy.
- Audit and update all hardcoded text across:
  - Navigation & Headers (`TopNavHeaderView`, `ConvertHeadingView`, `SettingsHeadingView`)
  - Dashboard & Tables (`DashboardScene`, `ConversionsTableView`, `ConversionDetailModalView`, `MetricsHeaderView`)
  - Convert & Inspection (`BatchDropzoneView`, `BatchQueueView`, `BatchQueueItemRow`, `ImportRejectionListView`, `SquooshInspectorView`, `OutputSettingsView`)
  - Settings Panels (`AppearancePanelView`, `LanguagePanelView`, `WorkflowPanelView`, `SettingsSidebarView`)
  - Footers (`TelemetryFooterView`, `StatusFooterView`)
- Add unit tests in `Monarch-conversionsTests` verifying localized string resolution and locale mapping.

## Approach
- Create `Monarch-conversions/Localizable.xcstrings` supporting `en` (default) and `es`.
- Ensure all SwiftUI `Text`, `Button`, `Picker`, and formatting helpers use `LocalizedStringKey` or `String(localized:)`.
- Retain system architectural invariants (`App → Scenes → Features → Core`).
- Validate changes via `xcodebuild test`.
