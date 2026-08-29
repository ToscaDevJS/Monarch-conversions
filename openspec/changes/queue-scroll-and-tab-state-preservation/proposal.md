# Proposal: Queue Scroll View, Window Constraints & Tab State Preservation

## Intent

As identified in `LAUNCH-TRIAGE.md` (Defect 10 & Defect 11):
1. **Defect 10 (Queue Overflow & Window Layout)**:
   - In `BatchQueueView.swift`, items were rendered inside a non-scrolling `VStack`. Large batches pushed action buttons out of the viewport.
   - The root window group lacked minimum size constraints, allowing the window to be shrunk down to 0×0.
2. **Defect 11 (State Loss on Tab Switch)**:
   - In `RootView.swift:9-24`, switching tabs destroyed and recreated `ConvertScene`, wiping all queued items, selected items, and interrupting running batches.

## Scope

### In Scope
- Embed queue item list in `ScrollView` with `LazyVStack` to handle arbitrary queue sizes without UI overflow.
- Apply window minimum dimensions (`minWidth: 860, minHeight: 600`) to prevent UI collapsing.
- Preserve scene state across tab transitions in `RootView` using persistent `ZStack` with visibility toggling.
- Strict TDD: Unit tests verifying `BatchQueueView` scrolling container structure and `RootView` tab state preservation.

### Out of Scope
- Full multi-window persistence across application relaunch (data persistence is already handled by SwiftData).

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added requirements that queue items are scrollable, window maintains min dimensions, and tab transitions preserve queue state.

## Approach

1. **RED Phase**:
   - Write tests in `Monarch-conversionsTests/QueueLayoutAndTabStateTests.swift` testing tab state retention semantics and minimum layout constraints.
   - Run `xcodebuild test` to observe failure.
2. **GREEN Phase**:
   - Update `BatchQueueView.swift` with `ScrollView`.
   - Update `RootView.swift` to keep scenes alive across tab navigation.
   - Update `Monarch_conversionsApp.swift` with minimum window constraints.
   - Run `xcodebuild test` to observe pass.
3. **REFACTOR Phase**:
   - Full test suite run and SDD verification.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions/Features/Conversions/Views/BatchQueueView.swift` | Modified | Add `ScrollView` wrapper around item list |
| `Monarch-conversions/App/RootView.swift` | Modified | Preserve tab view hierarchies in `ZStack` |
| `Monarch-conversions/App/Monarch_conversionsApp.swift` | Modified | Set `minWidth: 860, minHeight: 600` |
| `Monarch-conversionsTests/QueueLayoutAndTabStateTests.swift` | New | Swift Testing tests for tab state retention |
| `openspec/changes/queue-scroll-and-tab-state-preservation/` | New | SDD specifications and verification report |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Inactive tabs receiving user clicks | Low | Use `.allowsHitTesting(isActive)` |

## Success Criteria

- [ ] Queue scrolls smoothly for any batch size.
- [ ] Switching between Dashboard/Settings and Convert preserves all queued items and selections.
- [ ] Window has minimum dimensions of 860×600.
- [ ] 100% tests pass in `xcodebuild test`.
