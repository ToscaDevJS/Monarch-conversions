# Proposal: Background Batch Conversion, Cancellation Handle & Error Diagnostics

## Intent

As identified in `LAUNCH-TRIAGE.md` (Defect 08 & Defect 09):
1. **Defect 08 (Main Thread Freeze)**: In `ConvertScene.swift:74`, the batch conversion loop was launched via a basic `Task { ... }` block inheriting `@MainActor` from the SwiftUI View hierarchy. As a result, image decompression, scaling, and compression were executed directly on the main thread, freezing the UI (preventing window interaction, animation frames, and hover states).
2. **Defect 09 (Silent Failures & Missing Cancellation)**: Conversion errors were printed to the debug console without persisting failure diagnostic information to the user. Additionally, there was no cancellation mechanism (`Task.isCancelled` check or `cancel()` handle) to abort a long-running batch conversion.

## Scope

### In Scope
- Add `errorMessage: String?` property to `BatchQueueItem` to capture failure diagnostics.
- Update `ConvertScene` to execute image conversions in `Task.detached(priority: .userInitiated)` with hops back to `@MainActor` for state and `ModelContext` mutations.
- Check `Task.isCancelled` before and after each conversion step to halt queue processing immediately when cancelled.
- Expose batch cancellation handle in `ConvertScene` and provide cancel action in `BatchStatusFooterView`.
- Show failure reason tooltip/badge when an item has `status == .failed`.
- Strict TDD: Unit tests in `BatchQueueItemStatusTests.swift` and `BatchQueueConversionTests.swift`.

### Out of Scope
- Custom per-file retry policies (users can re-run the batch or convert individual items).

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added requirements for non-blocking background batch execution, cooperative task cancellation, and diagnostic error persistence on failed batch items.

## Approach

1. **RED Phase**:
   - Write tests in `BatchQueueConversionTests.swift` verifying `errorMessage` storage on failure and cooperative task cancellation semantics.
   - Run `xcodebuild test` to observe failure.
2. **GREEN Phase**:
   - Update `BatchQueueItem.swift` with `errorMessage: String?`.
   - Update `BatchQueueItemRow.swift` with tooltip diagnostics for failed items.
   - Update `BatchStatusFooterView.swift` to support `onCancel`.
   - Update `ConvertScene.swift` with `Task.detached`, cancellation checks, and `@MainActor` state synchronization.
   - Run `xcodebuild test` to observe pass.
3. **REFACTOR Phase**:
   - Verify full test suite and finalize SDD verification.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions/Features/Conversions/Models/BatchQueueItem.swift` | Modified | Add `errorMessage: String?` |
| `Monarch-conversions/Scenes/Convert/ConvertScene.swift` | Modified | Detached background task, cancellation, error assignment |
| `Monarch-conversions/Features/Conversions/Views/BatchStatusFooterView.swift` | Modified | Add `onCancel` handler support |
| `Monarch-conversions/Features/Conversions/Views/BatchQueueItemRow.swift` | Modified | Display tooltip with error message on failed rows |
| `Monarch-conversionsTests/BatchQueueConversionTests.swift` | Modified | Add tests for cancellation and error capture |
| `openspec/changes/background-batch-conversion-and-cancellation/` | New | SDD change specifications and verification |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Thread safety with SwiftData ModelContext | Low | SwiftData mutations explicitly isolated to `@MainActor` |

## Success Criteria

- [ ] Heavy conversion loop runs off `@MainActor` in `Task.detached`.
- [ ] In-flight batch conversion can be cancelled at any time.
- [ ] Conversion failures store diagnostic error message on `BatchQueueItem`.
- [ ] 100% tests pass in `xcodebuild test`.
