# Tasks: Interactive Table Filtering & Reset Controls

## Unit 1: Filter State & Data Filtering Logic
- [x] Create `TableFilterState` struct in `Features/Conversions/Models/TableFilterState.swift`.
- [x] Add filtering extension / computed property `filtered(with state: TableFilterState)` on `[ConversionRecord]`.

## Unit 2: UI Menu Integration & Reset Action
- [x] Refactor `FilterDropdown` in `ConversionsTableView.swift` to support `Menu` picking.
- [x] Wire `Status`, `Input`, `Output`, and `Project` dropdown menus to `@State private var filterState`.
- [x] Wire `Reset` button to call `filterState.reset()` and adjust opacity when inactive.

## Unit 3: Verification & Unit Tests
- [x] Create `TableFilteringTests.swift` testing state filtering and reset behavior.
- [x] Run `xcodebuild test` and produce `verify-report.md`.
