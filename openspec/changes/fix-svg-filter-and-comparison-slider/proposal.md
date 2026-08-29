# Proposal: SVG Output Exclusion & Comparison Slider Real Output URL

## Intent

As identified in `LAUNCH-TRIAGE.md` (Defect 05 & Defect 06):
1. **SVG Output Exclusion (Defect 05)**: `ImageFormat.outputEligibleCases` excluded `.webp`, `.jpegXL`, and `.dng`, but forgot `.svg`. Because SVG does not have a CoreGraphics/ImageIO bitmap destination UTI (`uti(for: .svg)` is `nil`), selecting SVG in output format menus caused 100% conversion failures.
2. **Comparison Slider Real Output (Defect 06)**: `ConvertScene` passed `imageURL: selectedItem?.fileURL` to `SquooshInspectorView`, and the inspector loaded that same source URL on both sides of the split comparison view. Converted items rendered identical images on both sides of the slider instead of displaying the actual converted output from `selectedItem?.outputFileURL`.

## Scope

### In Scope
- Filter `.svg` out of `ImageFormat.outputEligibleCases`.
- Add `outputImageURL: URL?` property to `SquooshInspectorView` and render the output file on the optimized right-side comparison pane.
- Pass `outputImageURL: selectedItem?.outputFileURL` in `ConvertScene.swift`.
- Strict TDD: Unit tests in `ImageFormatTests.swift` and `SquooshInspectorViewTests.swift`.

### Out of Scope
- Re-architecting the slider gesture or zoom mechanics.

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added explicit requirement that `.svg` is excluded from output-eligible target formats.
- `conversion-formatting`: Added requirement that the inspection slider renders original source URL on left and converted output URL on right.

## Approach

1. **RED Phase**:
   - Add test assertion `#expect(!ImageFormat.outputEligibleCases.contains(.svg))` in `ImageFormatTests.swift`.
   - Add test in `SquooshInspectorViewTests.swift` verifying `outputImageURL` initialization and distinct URL separation.
   - Run `xcodebuild test` to observe failure.
2. **GREEN Phase**:
   - Update `ImageFormat.swift` to filter `$0 != .svg`.
   - Update `SquooshInspectorView.swift` to accept and render `outputImageURL`.
   - Update `ConvertScene.swift` to pass `outputImageURL: selectedItem?.outputFileURL`.
   - Run `xcodebuild test` to observe pass.
3. **REFACTOR Phase**:
   - Full test suite verification and SDD completion.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions/Features/Conversions/Models/ImageFormat.swift` | Modified | Exclude `.svg` from `outputEligibleCases` |
| `Monarch-conversions/Features/Conversions/Views/SquooshInspectorView.swift` | Modified | Accept and render `outputImageURL` on right comparison pane |
| `Monarch-conversions/Scenes/Convert/ConvertScene.swift` | Modified | Pass `outputImageURL: selectedItem?.outputFileURL` |
| `Monarch-conversionsTests/ImageFormatTests.swift` | Modified | Added assertion for `.svg` exclusion |
| `Monarch-conversionsTests/SquooshInspectorViewTests.swift` | Modified | Added tests for output URL separation |
| `openspec/changes/fix-svg-filter-and-comparison-slider/` | New | SDD specifications and verification report |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Broken preview when output is not yet converted | Low | Fallback to original image or placeholder if `outputImageURL` is nil |

## Success Criteria

- [ ] `ImageFormat.outputEligibleCases` does not contain `.svg`.
- [ ] `SquooshInspectorView` renders `outputImageURL` on the optimized comparison pane.
- [ ] 100% tests pass in `xcodebuild test`.
