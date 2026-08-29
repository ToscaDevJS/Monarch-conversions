# Tasks: Prevent Batch Duplicate Conversions

## Unit 1: Strict TDD Test Suite (RED)
- [x] Create `Monarch-conversionsTests/BatchQueueConversionTests.swift`.
- [x] Run `xcodebuild test` to verify RED phase failure.

## Unit 2: Implementation (GREEN)
- [x] Update `ConvertScene.swift` to filter for `status == .queued` in `processBatchConversion`.
- [x] Add `guard !isProcessing` to `clearQueue()` and `deleteSelectedItem()`.
- [x] Run `xcodebuild test` and confirm GREEN phase pass.

## Unit 3: Verification & SDD
- [x] Run full test suite with 0 regressions.
- [x] Produce `verify-report.md` and complete SDD verification.
