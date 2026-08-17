# Tasks: Purge Mock Seeds & Add Table Empty State

## Unit 1: Purge Mock Seeds & Clean MetricsHeaderView
- [x] Remove `ConversionSeedService.swift` and `ConversionSeedServiceTests.swift`.
- [x] Clean `MetricsHeaderView.swift` removing fake sparkline curves and ASCII glyphs.
- [x] Add legacy seed data cleanup routine in `DashboardScene.swift`.

## Unit 2: Conversions Table Empty State
- [x] Add `TableEmptyStateView` to `ConversionsTableView.swift` for 0 records and no-search-match states.
- [x] Wire "Go to Convert (⌘2)" navigation button.

## Unit 3: Verification & Tests
- [x] Run full test suite (`xcodebuild test`) and produce `verify-report.md`.
