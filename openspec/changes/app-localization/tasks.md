# Tasks: App Localization

Tags: AL-1 Catalog, AL-2 Environment locale, AL-3 Views, AL-4 Formatting, AL-5 Tests.

## Phase 1: Foundation & Catalog (Unit 1)

- [x] 1.1 Create `Localizable.xcstrings` in `Monarch-conversions/` with `en` and `es` localizations [AL-1]
- [x] 1.2 Update `RootView.swift` to pass `.environment(\.locale, userSettings.language.locale)` [AL-2]
- [x] 1.3 Create `Monarch-conversionsTests/AppLocalizationTests.swift` verifying locale mapping and key resolution [AL-5]

## Phase 2: Navigation & Common Components (Unit 2)

- [x] 2.1 Localize `TopNavHeaderView.swift` tab titles (STUDIO, CONVERT, SETTINGS) [AL-3]
- [x] 2.2 Localize `TelemetryFooterView.swift` and `StatusFooterView.swift` [AL-3]
- [x] 2.3 Localize `GlobalSearchBarView.swift` [AL-3]

## Phase 3: Conversions Feature Views (Unit 3)

- [x] 3.1 Localize `ConvertHeadingView.swift`, `BatchDropzoneView.swift`, and `BatchQueueView.swift` [AL-3]
- [x] 3.2 Localize `BatchQueueItemRow.swift` and `ImportRejectionListView.swift` [AL-3]
- [x] 3.3 Localize `SquooshInspectorView.swift` and `OutputSettingsView.swift` [AL-3]
- [x] 3.4 Localize `DashboardScene.swift`, `MetricsHeaderView.swift`, `ConversionsTableView.swift`, and `ConversionDetailModalView.swift` [AL-3]

## Phase 4: Settings Feature Views & Verification (Unit 4)

- [x] 4.1 Localize `SettingsHeadingView.swift` and `SettingsSidebarView.swift` [AL-3]
- [x] 4.2 Localize `AppearancePanelView.swift`, `LanguagePanelView.swift`, and `WorkflowPanelView.swift` [AL-3]
- [x] 4.3 Run full `xcodebuild test` suite and verify Spanish/English UI toggling [AL-5]
