# Tasks: DNG RAW Image Import & Conversion Support

## Phase 1: Format Definition & Import Service (Strict TDD Red -> Green)
- [x] 1.1 Add failing unit test assertions for `.dng` raw value and extension in `ImageFormatTests.swift` (RED).
- [x] 1.2 Implement `case dng = "DNG"` and mapping in `ImageFormat.swift` and verify test passes (GREEN).
- [x] 1.3 Update `ImageFormat.outputEligibleCases` to exclude `.dng` (decode-only).
- [x] 1.4 Add `"dng"` to `ImageImportService.allowedContentTypes` in `ImageImportService.swift`.
- [x] 1.5 Update `ImageConversionService.uti(for:)` to handle `.dng` in `ImageConversionService.swift`.

## Phase 2: Unit Testing & Verification
- [x] 2.1 Add failing import test for real ProRAW DNG file in `ImageImportServiceTests.swift` (RED).
- [x] 2.2 Add conversion test from real ProRAW DNG to JPEG in `ImageConversionServiceTests.swift` (GREEN).
- [x] 2.3 Run full test suite with `xcodebuild test` and generate `verify-report.md`.
