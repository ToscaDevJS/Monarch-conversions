# Tasks: Delete Conversion History & Records

## Phase 1: Localization & String Catalogs
- [x] 1.1 Add `table.clear_history`, `table.clear_history_title`, `table.clear_history_message`, `table.clear_history_confirm`, and `table.delete_record` to `Conversions.xcstrings`.
- [x] 1.2 Add `action.cancel` and `action.delete` to `Common.xcstrings`.

## Phase 2: Table & Modal View Implementation
- [x] 2.1 Add "Clear History" button and `.confirmationDialog` to `ConversionsTableView.swift`.
- [x] 2.2 Wire `clearAllHistory()` and `deleteRecord(_:)` methods using `modelContext`.
- [x] 2.3 Add "Delete Record" action to `TableRowView` context menu in `ConversionsTableView.swift`.
- [x] 2.4 Add "Delete" button and `onDelete` callback in `ConversionDetailModalView.swift`.
- [x] 2.5 Connect `onDelete` handler in `DashboardScene.swift`.

## Phase 3: Unit Testing & Verification
- [x] 3.1 Update `AppLocalizationTests.swift` to verify all new localization keys resolve correctly.
- [x] 3.2 Run test suite via `xcodebuild test` and produce `verify-report.md`.
