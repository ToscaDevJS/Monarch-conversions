# Tasks: Real Image Preview in Squoosh Inspector

## Unit 1: Real Image Loading & Render Flow
- [x] Add `imageURL: URL? = nil` parameter to `SquooshInspectorView.swift`.
- [x] Load `NSImage(contentsOf: url)` and render `Image(nsImage:)` in comparison slider.
- [x] Update `ConvertScene.swift` to pass `selectedItem.fileURL` to `SquooshInspectorView`.

## Unit 2: Verification & Unit Tests
- [x] Create `SquooshInspectorViewTests.swift` testing URL binding.
- [x] Run `xcodebuild test` and produce `verify-report.md`.
