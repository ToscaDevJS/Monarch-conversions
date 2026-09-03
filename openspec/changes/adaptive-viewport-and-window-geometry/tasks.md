# Tasks: Adaptive Viewport Geometry, Vertical Overflow & Window Expansion

## Phase 1: Test Suite & Failure Demonstration (RED)
- [x] 1.1 Create `Monarch-conversionsTests/ViewportGeometryTests.swift`.
- [x] 1.2 Add test asserting `MonarchUI.Layout.minWindowHeight >= 700` and documenting the vertical arithmetic sum.
- [x] 1.3 Add test asserting maximum content width bounds for Settings on wide viewports.
- [x] 1.4 Add test verifying `ConvertScene` structural scroll hierarchy.
- [x] 1.5 Run `xcodebuild test` to demonstrate RED failure.

## Phase 2: Layout Constants & Core Invariants (GREEN)
- [x] 2.1 Update `MonarchUI.swift`:
  - [x] 2.1.1 Adjust `minWindowHeight` from 600 to 700 with documented arithmetic.
  - [x] 2.1.2 Add `Layout.Settings.maxContainerWidth` (1280pt).
  - [x] 2.1.3 Add `Layout.Convert.maxContentWidth` (1440pt) and destination box max width.
- [x] 2.2 Update `Monarch_conversionsApp.swift` to use updated minimum window bounds.

## Phase 3: Scene-Level Viewport Implementation (GREEN)
- [x] 3.1 Refactor `ConvertScene.swift`:
  - [x] 3.1.1 Wrap content body in a vertical `ScrollView`.
  - [x] 3.1.2 Pin `TopNavHeaderView` at top and `BatchStatusFooterView` at bottom.
  - [x] 3.1.3 Apply max container width to prevent infinite horizontal blowout on 27" screens.
- [x] 3.2 Refactor `SettingsScene.swift`:
  - [x] 3.2.1 Center the sidebar + detail panel container horizontally on wide viewports.
  - [x] 3.2.2 Clamp maximum container width to prevent dead space asymmetry.
- [x] 3.3 Refactor `OutputSettingsView.swift`:
  - [x] 3.3.1 Clamping `destinationBox` max width so it scales proportionally with other setting boxes.

## Phase 4: Verification & Regression Check (REFACTOR)
- [x] 4.1 Run `xcodebuild test` and verify all tests pass (0 regressions).
- [x] 4.2 Test layouts visually and via tests at 1180×700, 1440×900, and 2560×1440.
- [x] 4.3 Create `verify-report.md` documenting test results and architectural resolution.
