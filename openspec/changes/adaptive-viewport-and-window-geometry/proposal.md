# Proposal: Adaptive Viewport Geometry, Vertical Overflow & Window Expansion

## Intent

Empirical code inspection and geometric arithmetic reveal two major layout defects in window sizing and viewport responsiveness:

1. **Vertical Content Clipping at Minimum Window Height (600pt)**:
   - `MonarchUI.Layout.minWindowHeight` is set to `600pt`, but `ConvertScene` requires a minimum of **824pt** (empty queue) and **868pt–904pt** (populated queue) to display its content without clipping.
   - `ConvertScene` lacks an outer vertical `ScrollView`. At the current minimum window height (1180×600), between **224pt and 304pt** of content is pushed off-screen, rendering the primary action button ("Convert Batch") and/or the batch status footer completely inaccessible.
   - `BatchQueueView` has a fixed `.frame(maxHeight: 340)` for its list, but neither it nor `BatchDropzoneView` adapts when vertical space is constrained.

2. **Unconstrained Horizontal & Vertical Expansion on Large Displays**:
   - In `SettingsScene`, `detailMaxWidth` is capped at `770pt` within a left-aligned container (`HStack(alignment: .top) ... .frame(maxWidth: .infinity, alignment: .leading)`). On a 27" display (2560×1440), content occupies only ~1042pt, leaving ~1500pt of dead negative space on the right edge.
   - In `ConvertScene`, the left column is rigidly capped at `maxWidth: 520`, while the right column stretches infinitely. The visual inspector expands horizontally without scaling its inner preview proportionally, and `destinationBox` stretches across the entire remaining screen width. Vertically, `Spacer(minLength: 0)` pushes the footer away from fixed-height cards, creating a large empty gap.

This change establishes verified arithmetic for vertical viewport constraints, introduces vertical scrolling safety to prevent content loss, and defines responsive scaling behaviors for wide and ultra-wide viewports.

## Scope

### In Scope
- **Arithmetic-Backed Window Minimums**: Recalculate and formally document minimum window dimensions in `MonarchUI.Layout` (ensuring compatibility with standard 13" MacBook screens ~720–768pt usable height).
- **Scene-Level Scroll Safety in `ConvertScene`**: Enclose the main content of `ConvertScene` in a vertical `ScrollView` so that viewports shorter than the natural content height never clip controls or footers.
- **Adaptive Queue & Dropzone Geometry**: Allow `BatchDropzoneView` and `BatchQueueView` to share available vertical space dynamically or provide a compact mode when the queue is populated.
- **Wide-Display Layout Behavior**:
  - Center or proportionally constrain `SettingsScene` content on viewports exceeding standard desktop widths to prevent extreme left-anchored asymmetry.
  - Define max-width clamping or proportional column distribution in `ConvertScene` (preventing infinite stretch of `destinationBox` and unproportional inspector scaling).
- **Strict TDD**: Unit tests verifying layout arithmetic, minimum bounds, and scroll container presence.

### Out of Scope
- Multi-window split or separate inspector popout windows.
- Redesigning the core Paper design system tokens or color palette.

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added requirements that `ConvertScene` guarantees accessibility of all controls on any supported window size via vertical scrolling and adaptive height distribution.
- `appearance-preference` / `ui-layout`: Added requirements for responsive horizontal alignment and max-width constraints on wide displays.

## Approach

1. **RED Phase**:
   - Write tests in `Monarch-conversionsTests/ViewportGeometryTests.swift` validating:
     - Geometric arithmetic invariants (`minWindowHeight` vs required scene height).
     - Presence of vertical scroll hierarchy in `ConvertScene`.
     - Layout constraints for column and setting boxes.
   - Run `xcodebuild test` to observe failure.
2. **GREEN Phase**:
   - Wrap `ConvertScene` content in a vertical `ScrollView` (leaving `TopNavHeaderView` and `BatchStatusFooterView` as fixed chrome or scrolling appropriately).
   - Update `MonarchUI.Layout` with validated arithmetic constants for min and recommended window dimensions.
   - Refine `SettingsScene` layout with centering / max container constraints for wide viewports.
   - Constrain `OutputSettingsView` and `SquooshInspectorView` proportions on wide viewports.
   - Run `xcodebuild test` to observe pass.
3. **REFACTOR Phase**:
   - Verify all scenes on 1180×600 (minimum bound), 1440×900 (typical laptop), and 2560×1440 (27" display).
   - Ensure 0 regressions across existing test suite.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions/Core/Theme/MonarchUI.swift` | Modified | Update `Layout` enum with verified minimum heights and container max widths |
| `Monarch-conversions/Scenes/Convert/ConvertScene.swift` | Modified | Add vertical `ScrollView` and responsive column container |
| `Monarch-conversions/Scenes/Settings/SettingsScene.swift` | Modified | Center/constrain content on ultra-wide viewports |
| `Monarch-conversions/Features/Conversions/Views/BatchQueueView.swift` | Modified | Adaptive height handling for queue vs dropzone |
| `Monarch-conversions/Features/Conversions/Views/OutputSettingsView.swift` | Modified | Cap maximum width of destination box on wide screens |
| `Monarch-conversionsTests/ViewportGeometryTests.swift` | New | Swift Testing suite for layout arithmetic and scroll containment |

## Risks & Mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| Nested `ScrollView` conflict (`ConvertScene` outer vertical scroll vs `BatchQueueView` inner vertical scroll) | Medium | Use bounded height on `BatchQueueView` or disable outer scrolling when all content fits; use SwiftUI `.scrollBounceBehavior(.basedOnSize)`. |
| Breaking existing window size tests (`QueueLayoutAndTabStateTests`) | Low | Update existing tests to reflect mathematically verified constants. |
| Footer overlapping content in short windows | Low | Keep `BatchStatusFooterView` outside the `ScrollView` docked at bottom, with `ScrollView` content padding ensuring clearance. |

## Rollback Plan

If responsive changes cause regressions in keyboard shortcut accessibility or layout jitter:
1. Revert changes to `ConvertScene.swift` and `SettingsScene.swift`.
2. Restore previous layout constants in `MonarchUI.swift`.
3. Working tree is managed under Git version control.

## Success Criteria

- [ ] On a 1180×600 window with 30 items in the queue, all items, settings, and the "Convert Batch" button are fully reachable via scrolling without visual clipping.
- [ ] On a 2560×1440 window, Settings content does not look like a broken column stranded on the far left.
- [ ] Layout arithmetic is explicitly documented and tested in code.
- [ ] 100% unit tests pass via `xcodebuild test`.
