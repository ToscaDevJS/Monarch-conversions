# Proposal: Typed Conversion Domain

## Intent

The Conversions feature stores presentation strings as domain data: `ConversionRecord` persists `dimensions: "4096 × 2731"` and `outputSize: "684 KB"`; `BatchQueueItem` stores `originalSize: "2.8 MB"` and `reductionPercentage: "-85%"`. A real conversion engine cannot compare sizes, compute reductions, or validate formats on strings. Replace presentation-typed fields with typed domain values so future changes (file import, engine) target a real domain.

## Scope

### In Scope
- Typed value types in `Features/Conversions/Models/`: `ImageFormat` enum, numeric width/height dimensions, integer byte counts.
- `ConversionRecord` (SwiftData) and `BatchQueueItem` migrated to typed fields; reduction percentage computed from byte counts, never stored.
- `isSelected` moved out of `BatchQueueItem` into scene-level selection state.
- Formatting ("2.8 MB", "4096 × 2731", "-85%") moves to the presentation layer; seed service and all consumer views updated.
- TDD-first unit tests for domain types and formatting.

### Out of Scope
- Real file import (drop / NSOpenPanel); the conversion engine; wiring Dashboard to real conversions.
- Removing the seed service (stays, seeding typed values).
- SwiftData versioned migration (seed data is disposable — see Risks).

## Capabilities

### New Capabilities
- `conversion-domain`: typed conversion domain — image formats, pixel dimensions, byte counts, computed reduction, status lifecycle.
- `conversion-formatting`: presentation formatting of conversion values (sizes, dimensions, percentages) for feature views and scenes.

### Modified Capabilities
None — `openspec/specs/` does not exist yet.

## Approach

1. Strict TDD: unit tests for `ImageFormat`, dimensions, reduction computation, and formatters first.
2. Add typed value types (one type per file) in `Features/Conversions/Models/`.
3. Migrate `ConversionRecord` fields; keep `ConversionStatus`; regenerate the store instead of migrating (data is fake seed).
4. Migrate `BatchQueueItem`; move selection state to `ConvertScene`.
5. Formatting helpers live in the Conversions feature presentation layer; scenes consume them (App → Scenes → Features → Core preserved).

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Features/Conversions/Models/ConversionRecord.swift`, `BatchQueueItem.swift` | Modified | Typed fields; computed reduction; selection removed |
| `Features/Conversions/Models/` new type files | New | `ImageFormat`, dimensions, formatting |
| `Features/Conversions/Services/ConversionSeedService.swift` | Modified | Seed typed values |
| `ConversionsTableView`, `ConversionDetailModalView`, `BatchQueueView`, `BatchQueueItemRow` | Modified | Format at presentation |
| `Scenes/Convert/ConvertScene.swift`, `Scenes/Dashboard/DashboardScene.swift` | Modified | Typed mocks; formatting |
| `Monarch-conversionsTests/` | New | Domain + formatting tests |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| SwiftData schema change invalidates local store | Med | All data is disposable seed; regenerate store |
| Exceeds 400-line review budget | High | sdd-tasks slices chained PRs: types+tests → models+seed → views |
| Closed `ImageFormat` enum too rigid for engine | Low | Raw-value-backed; design defines unknown-format handling |
| Visible UI strings drift | Low | Formatter tests assert today's exact strings |

## Rollback Plan

Revert the change commits (no external contracts, no real user data), delete the local SwiftData store, relaunch — seed regenerates. Chained PRs revert in reverse order.

## Dependencies

None external. Future file-import and engine changes depend on this.

## Success Criteria

- [ ] No presentation strings ("KB", "×", "%") stored in `Features/Conversions/Models/`.
- [ ] Byte counts integer, dimensions numeric, formats enum, reduction computed.
- [ ] TDD-first tests pass via `xcodebuild test`; UI renders the same visible strings as before.
- [ ] Dependency direction preserved; no feature-to-feature imports.
