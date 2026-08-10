# Tasks: Global Search Bar & UI Button Actions

## Unit 1: Table Search Filtering & ⌘K Focus Shortcut
- [x] Add `searchText: String` property to `TableFilterState` and update `filtered(with:)` matching.
- [x] Bind `searchText` in `ConversionsTableView` and pass from `DashboardScene`.
- [x] Add `@FocusState` and `⌘K` keyboard shortcut in `GlobalSearchBarView`.

## Unit 2: Functional Copy Name, Open Original, & ESC Key Actions
- [x] Wire "Copy name" button in `ConversionDetailModalView` to `NSPasteboard`.
- [x] Wire "Open original" button in `ConversionDetailModalView` to `NSWorkspace`.
- [x] Wire `ESC` keyboard shortcut to trigger `onClose` in `ConversionDetailModalView`.

## Unit 3: Verification & Unit Tests
- [x] Create `GlobalSearchAndActionsTests.swift` testing search query matching.
- [x] Run `xcodebuild test` and produce `verify-report.md`.
