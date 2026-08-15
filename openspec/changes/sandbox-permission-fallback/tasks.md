# Tasks: App Sandbox Permission Fallback & Bookmark Management

## Unit 1: Core Service & Fallback Destination Resolution
- [x] Add `wasFallback: Bool` property to `ImageConversionResult`.
- [x] Add `isFallbackDestination: Bool` property to `BatchQueueItem`.
- [x] Implement pre-flight writable directory check and automatic `Downloads` fallback in `ImageConversionService.swift`.
- [x] Add security-scoped resource bracketing for custom output directories in `ImageConversionService.swift`.

## Unit 2: UI Visual Indicators & Pipeline Wiring
- [x] Update `ConvertScene.swift` to propagate `wasFallback` to `BatchQueueItem.isFallbackDestination`.
- [x] Update `BatchQueueItemRow.swift` to display "Saved to Downloads" fallback indicator badge.

## Unit 3: Verification & Tests
- [x] Add unit tests in `ImageConversionServiceTests.swift` validating fallback behavior when parent directory is not writable.
- [x] Run full test suite to ensure 0 regressions.
- [x] Produce `verify-report.md` and complete SDD verification.
