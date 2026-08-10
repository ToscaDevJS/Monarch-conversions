# Tasks: Adaptive Light and Dark Mode Appearance

## Phase 1: Dynamic Design System Tokens (Unit 1)

- [x] 1.1 Add `Color(light:dark:)` adaptive initializer extension in `MonarchUI.swift` [AM-1]
- [x] 1.2 Update all `MonarchUI.Color` tokens to define light and dark color variants [AM-1]

## Phase 2: Feature Views & Components Migration (Unit 2)

- [x] 2.1 Refactor Conversions feature views (`BatchDropzoneView.swift`, `BatchQueueItemRow.swift`, `SquooshInspectorView.swift`, `ConversionDetailModalView.swift`, etc.) to use semantic `MonarchUI.Color` tokens [AM-2]
- [x] 2.2 Refactor Settings feature views (`AppearancePanelView.swift`, `LanguagePanelView.swift`, `SettingsSidebarView.swift`, etc.) to use semantic `MonarchUI.Color` tokens [AM-2]
- [x] 2.3 Refactor Navigation, Search, and Footer views (`TopNavHeaderView.swift`, `GlobalSearchBarView.swift`, `TelemetryFooterView.swift`, `StatusFooterView.swift`) to use semantic `MonarchUI.Color` tokens [AM-2, AM-3]

## Phase 3: Tests & Full Verification (Unit 3)

- [x] 3.1 Create `MonarchUITests.swift` verifying dynamic `MonarchUI.Color` tokens [AM-4]
- [x] 3.2 Update `UserSettingsTests.swift` verifying `preferredColorScheme` mapping for `.dark`, `.light`, and `.system` [AM-3, AM-4]
- [x] 3.3 Run `xcodebuild test` suite and verify 100% pass rate [AM-4]
