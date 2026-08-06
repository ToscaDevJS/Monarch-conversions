# Design: Typed Conversion Domain

## Technical Approach

Replace presentation strings in the Conversions domain with typed values and concentrate all string production in one pure presentation helper inside the feature. Domain types (`ImageFormat`, `PixelDimensions`, `Int64` byte counts) and the formatter import Foundation only — no SwiftUI — so strict TDD unit tests hit them directly. Seed and scene mocks supply byte/pixel values chosen so formatters reproduce today's exact visible strings. Layering unchanged: App → Scenes → Features → Core; formatting stays in the feature's presentation layer, scenes consume it (allowed direction).

No sequence diagram: per config rule, flows here are single-pass render formatting — not genuinely complex.

## Architecture Decisions

### D1 — Unknown/future format handling
| Option | Tradeoff |
|---|---|
| `.other(String)` case | Smears "unsupported" through every switch; breaks exhaustiveness; complicates Codable/SwiftData |
| Open struct wrapper | No compile-time exhaustiveness at all |
| **Closed enum + failable init (chosen)** | Unknown = unsupported, rejected at the import boundary |

**Choice**: `enum ImageFormat: String, Codable, CaseIterable, Sendable` with today's stored strings as explicit raw values — `case png = "PNG"`, `case jpg = "JPG"`, `case webp = "WebP"`, `case avif = "AVIF"`, `case svg = "SVG"`, `case tif = "TIF"` — plus `init?(fileExtension:)` (case-insensitive, maps `jpeg`→`.jpg`, `tiff`→`.tif`). The raw value IS the display string, so the spec's "Known format round-trip" scenario (`ImageFormat(rawValue: "PNG")` etc.) passes by construction and no separate `displayName` mapping exists. **Rationale**: supported formats are a product decision in a converter; the future engine rejects unknown files at the boundary (later change) instead of carrying them through the domain. Adding a case is one enum line + exhaustive-switch compiler errors.

### D2 — Formatter placement and API
**Choice**: one file `Monarch-conversions/Features/Conversions/Views/ConversionFormatting.swift` — enum namespace, static pure functions, Foundation-only:
```swift
enum ConversionFormatting {
    static func byteSize(_ bytes: Int64) -> String          // "684 KB", "2.8 MB"
    static func dimensions(_ d: PixelDimensions) -> String  // "4096 × 2731"
    static func reduction(percent: Int) -> String           // "-85%"
}
```
Format names need no formatter: views render `ImageFormat.rawValue` directly ("PNG", "WebP", "TIF" — see D1), applying `.uppercased()`/`.prefix(1)` where today's UI does.
**Alternatives rejected**: computed properties per view (duplication, untestable in isolation); `Core/` (single-feature consumer — violates "grow by pain"). Byte rule is locale-independent by hand (decimal base 1000; `< 1 MB` → integer KB; `≥ 1 MB` → one-decimal MB) — `ByteCountFormatter` output varies by locale and would break exact-string tests. Preserved string catalog (formatter test fixtures): `"684 KB"`, `"1.2 MB"`, `"2.8 MB"`, `"4096 × 2731"`, `"-85%"`; `"WebP"`/`"TIF"` come from `ImageFormat.rawValue`.

### D3 — Byte-count type
**Choice**: `Int64` for all byte counts; `Int` for pixel dimensions. **Rationale**: byte counts are inherently 64-bit quantities (`ByteCountFormatter`, `FileManager` attributes use `Int64`); the 100 MB UI copy is product policy, not a type bound. Explicit width beats platform-dependent `Int` for persisted quantities.

### D4 — Pending target size / reduction
**Choice**: `BatchQueueItem.targetSizeBytes: Int64?`; `var reductionPercent: Int?` computed (`nil` when no target; rounded `(target−original)/original×100`). Row renders the full `"WebP · 420 KB (-85%)"` string when target exists, format name only when `nil`. **Rationale**: a real queue item has no output before conversion; seeds always provide targets so no visible change today. Verified against seeds: 4.1 MB→780 KB = −81%, 450 KB→85 KB = −81% (rounding matches current strings). Final pending-state UI belongs to the engine change.

### D5 — Selection state relocation
**Choice**: delete `isSelected` from `BatchQueueItem`; `BatchQueueItemRow` gains `let isSelected: Bool`; `BatchQueueView` passes `selectedId == item.id` directly, removing today's per-row struct-copy hack. `ConvertScene` keeps `@State selectedId: UUID?`. **Rationale**: single-selection is ephemeral scene state, not domain data; also fixes the item-recreation anti-pattern.

### D6 — SwiftData schema change strategy
**Choice**: store regeneration, no versioned migration. Extend the existing `catch` in `Monarch_conversionsApp`: on persistent container failure, delete the default store files (`.store`, `-shm`, `-wal`), retry persistent once; in-memory remains last resort. `ConversionRecord` keeps the existing `statusRaw` pattern for enums (`inputFormatRaw` + computed `ImageFormat`, fallback `?? .png` — unreachable with a regenerated store). **Rationale**: all data is disposable seed. **Rollback**: revert commits, delete local store, relaunch — old seed regenerates. Any future change with real user data MUST replace this with versioned migration.

## Data Flow

    ConversionSeedService ─typed─▶ ConversionRecord (SwiftData)
        ─@Query─▶ ConversionsTableView / ConversionDetailModalView ─▶ ConversionFormatting ─▶ Text
    ConvertScene @State [BatchQueueItem] + selectedId
        ─▶ BatchQueueView ─(item, isSelected)─▶ BatchQueueItemRow ─▶ ConversionFormatting
        ─preformatted strings─▶ SquooshInspectorView (unchanged)

## File Changes

All under `Monarch-conversions/Monarch-conversions/` unless noted.

| File | Action | Description |
|---|---|---|
| `Features/Conversions/Models/ImageFormat.swift` | Create | D1 enum |
| `Features/Conversions/Models/PixelDimensions.swift` | Create | `struct { let width, height: Int }`, Equatable/Codable/Sendable |
| `Features/Conversions/Models/ConversionRecord.swift` | Modify | `inputFormatRaw`/`outputFormatRaw` + computed enums; `pixelWidth`/`pixelHeight` + computed `PixelDimensions`; `outputSizeBytes: Int64` |
| `Features/Conversions/Models/BatchQueueItem.swift` | Modify | Typed fields, optional target, computed reduction, drop `isSelected` |
| `Features/Conversions/Views/ConversionFormatting.swift` | Create | D2 |
| `Features/Conversions/Services/ConversionSeedService.swift` | Modify | Typed seeds reproducing today's strings |
| `Features/Conversions/Views/ConversionsTableView.swift`, `ConversionDetailModalView.swift` | Modify | Format at render |
| `Features/Conversions/Views/BatchQueueView.swift`, `BatchQueueItemRow.swift` | Modify | D5; format at render |
| `Scenes/Convert/ConvertScene.swift` | Modify | Typed mocks; builds inspector strings via `ConversionFormatting` |
| `App/Monarch_conversionsApp.swift` | Modify | D6 store-destroy retry |
| `../Monarch-conversionsTests/` (new files) | Create | Domain + formatting tests |

`DashboardScene` and `SquooshInspectorView` need no changes (composition-only / preformatted inputs) — narrower than the proposal assumed.

## Testing Strategy

| Layer | What | Approach |
|---|---|---|
| Unit | `ImageFormat` raw/extension inits; `reductionPercent` (incl. nil, rounding); `ConversionFormatting` exact strings (D2 catalog) | XCTest, pure — RED first |
| Unit | Seed service inserts typed records once | In-memory `ModelContainer` |
| UI | None new | Existing launch tests only |

## Threat Matrix

N/A — no routing, shell, subprocess, VCS/PR automation, executable-file classification, or process-integration boundary.

## Migration / Rollout

Store regeneration per D6; no flags, no phases. Chained-PR slicing (types+tests → models+seed → views) decided in sdd-tasks per the proposal's 400-line risk.

## Open Questions

- None blocking. Pending-target UI copy (D4 nil branch) is finalized by the future engine change.
