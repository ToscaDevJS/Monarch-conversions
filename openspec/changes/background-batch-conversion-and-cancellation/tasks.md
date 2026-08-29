# Tasks: Background Batch Conversion, Cancellation Handle & Error Diagnostics

## Unit 1: Strict TDD Test Suite (RED)
- [x] Add tests in `BatchQueueConversionTests.swift` for `errorMessage` diagnostics on failure and cooperative task cancellation.
- [x] Run `xcodebuild test` to observe failure in RED phase.

## Unit 2: Implementation (GREEN)
- [x] Add `errorMessage: String?` to `BatchQueueItem.swift`.
- [x] Update `BatchQueueItemRow.swift` to display tooltip with error diagnostics on `.failed` status.
- [x] Update `BatchStatusFooterView.swift` to accept and render `onCancel` button when `isProcessing == true`.
- [x] Update `ConvertScene.swift` with `Task.detached`, cooperative cancellation, and background conversion processing.
- [x] Run `xcodebuild test` to verify GREEN phase pass.

## Unit 3: Verification & SDD
- [x] Run full test suite with 0 regressions.
- [x] Produce `verify-report.md` and complete SDD verification.
