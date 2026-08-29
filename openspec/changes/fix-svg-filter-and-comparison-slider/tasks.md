# Tasks: SVG Output Exclusion & Comparison Slider Real Output URL

## Unit 1: Strict TDD Test Suite (RED)
- [x] Add `#expect(!ImageFormat.outputEligibleCases.contains(.svg))` in `ImageFormatTests.swift`.
- [x] Add `acceptsOutputImageURL` test in `SquooshInspectorViewTests.swift`.
- [x] Run `xcodebuild test` and verify RED phase failure.

## Unit 2: Implementation (GREEN)
- [x] Update `ImageFormat.swift` to exclude `.svg` from `outputEligibleCases`.
- [x] Update `SquooshInspectorView.swift` to accept `outputImageURL` and load output image.
- [x] Update `ConvertScene.swift` to pass `outputImageURL: selectedItem?.outputFileURL`.
- [x] Run `xcodebuild test` and verify GREEN phase pass.

## Unit 3: Verification & SDD
- [x] Run full test suite with 0 regressions.
- [x] Produce `verify-report.md` and complete SDD verification.
