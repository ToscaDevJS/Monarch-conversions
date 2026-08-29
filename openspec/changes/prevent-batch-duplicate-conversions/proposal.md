# Proposal: Prevent Batch Duplicate Conversions & History Redundancy

## Intent

As identified in `LAUNCH-TRIAGE.md` (Defect 04), `ConvertScene.swift:75` iterates over all items in the batch queue regardless of their current status. Clicking "Convert" again or triggering conversion on a partially completed batch re-processes already completed items (`status == .done`) and inserts duplicate `ConversionRecord` rows into SwiftData. This pollutes the Dashboard history, doubles metric calculations, and wastes CPU/IO resources.

## Scope

### In Scope
- Filter batch queue processing to only target items with `status == .queued`.
- Prevent duplicate conversions and duplicate `ConversionRecord` insertion into SwiftData.
- Protect queue mutations (`clearQueue`, `deleteSelectedItem`) while `isProcessing` is true to prevent index out of range traps (Defect 07).
- Strict TDD: Author tests in `Monarch-conversionsTests/BatchQueueConversionTests.swift` verifying that `.done` items are skipped and history records are not duplicated.

### Out of Scope
- Global pause/resume task cancellation handle (Tier 2 Defect 09).

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added requirement that batch queue processing only converts queued items and never re-converts or re-inserts completed items.

## Approach

1. **RED Phase**: Write tests in `Monarch-conversionsTests/BatchQueueConversionTests.swift` asserting that batch processing skips items where `status == .done` and prevents duplicate SwiftData inserts. Run `xcodebuild test` to observe failure.
2. **GREEN Phase**: Update `ConvertScene.swift` to filter for `.queued` items and guard queue modifications during processing.
3. **REFACTOR Phase**: Verify all tests pass, run full test suite with 0 regressions, and validate SDD compliance.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions/Scenes/Convert/ConvertScene.swift` | Modified | Filter batch loop by `status == .queued` and guard destructive actions |
| `Monarch-conversionsTests/BatchQueueConversionTests.swift` | New | Swift Testing unit tests for batch item filtering and duplicate prevention |
| `openspec/changes/prevent-batch-duplicate-conversions/` | New | SDD specifications and verification report |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Retrying failed items | Low | Failed items can transition back to `.queued` upon user retry |

## Success Criteria

- [ ] Re-triggering conversion skips `.done` items.
- [ ] No duplicate `ConversionRecord` entries are inserted into SwiftData.
- [ ] 100% tests pass in `xcodebuild test`.
