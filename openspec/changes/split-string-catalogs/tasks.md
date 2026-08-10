# Tasks: Split String Catalogs by Domain

Tags: SC-1 Domain Catalogs, SC-2 Table Mapping, SC-3 Monolith Removal, SC-4 Tests.

## Phase 1: Create Catalogs & Core Views (Unit 1)

- [x] 1.1 Create `Common.xcstrings`, `Conversions.xcstrings`, and `Settings.xcstrings` in `Monarch-conversions/` [SC-1]
- [x] 1.2 Remove `Localizable.xcstrings` [SC-3]
- [x] 1.3 Update `TopNavHeaderView.swift`, `GlobalSearchBarView.swift`, `TelemetryFooterView.swift`, and `StatusFooterView.swift` with `tableName: "Common"` [SC-2]
- [x] 1.4 Update `AppLocalizationTests.swift` to test all 3 catalogs [SC-4]

## Phase 2: Conversions Feature Views (Unit 2)

- [x] 2.1 Update `ConvertHeadingView.swift`, `BatchDropzoneView.swift`, and `BatchQueueView.swift` with `tableName: "Conversions"` [SC-2]
- [x] 2.2 Update `ImportRejectionListView.swift`, `SquooshInspectorView.swift`, and `OutputSettingsView.swift` with `tableName: "Conversions"` [SC-2]
- [x] 2.3 Update `MetricsHeaderView.swift`, `ConversionsTableView.swift`, and `ConversionDetailModalView.swift` with `tableName: "Conversions"` [SC-2]

## Phase 3: Settings Feature Views & Full Verification (Unit 3)

- [x] 3.1 Update `SettingsHeadingView.swift` and `SettingsSidebarView.swift` with `tableName: "Settings"` [SC-2]
- [x] 3.2 Update `AppearancePanelView.swift`, `LanguagePanelView.swift`, and `WorkflowPanelView.swift` with `tableName: "Settings"` [SC-2]
- [x] 3.3 Run `xcodebuild test` suite and verify 100% pass rate across all domain catalogs [SC-4]
