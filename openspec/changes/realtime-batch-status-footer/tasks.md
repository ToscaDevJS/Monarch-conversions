# Tasks: Realtime Connected Batch Status Footer

## Unit 1: Component Creation & Reactive Metrics
- [x] Create `BatchStatusFooterView.swift` accepting `items: [BatchQueueItem]`, `settings: ConversionSettings`, and `isProcessing: Bool`.
- [x] Implement computed properties for total original bytes, output bytes, done count, failed count, and batch reduction percentage.
- [x] Add folder reveal action on output directory pill.

## Unit 2: Scene Integration & Removal of Stale Footers
- [x] Replace `TelemetryFooterView` and `StatusFooterView` in `ConvertScene.swift` with the single `BatchStatusFooterView`.
- [x] Delete or refactor obsolete files `TelemetryFooterView.swift` and `StatusFooterView.swift`.

## Unit 3: Verification & Tests
- [x] Create `BatchStatusFooterTests.swift` validating aggregate calculations for empty, partial, and completed queues.
- [x] Run full test suite (`xcodebuild test`) and produce `verify-report.md`.
