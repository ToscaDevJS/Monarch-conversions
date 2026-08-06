# Tasks: Typed Conversion Domain

Tags: CDn / CFn = nth requirement of `conversion-domain` / `conversion-formatting` in `specs/spec.md`.

## Review Workload Forecast

Estimated changed lines: ~620–750 authored (U1 ~230, U2 ~280, U3 ~230).
Delivery strategy: ask-on-risk.
Suggested split: PR 1 types+formatter+tests → PR 2 record cluster → PR 3 batch cluster.

Decision needed before apply: Yes
Chained PRs recommended: Yes
Chain strategy: pending
400-line budget risk: High

Proposal's "models+seed → views" boundary breaks compilation mid-chain (views read old string fields); slices below are compile-coupled clusters, each building and testing green alone. `DashboardScene`/`SquooshInspectorView`: zero changes.

### Suggested Work Units

`RUN` = `xcodebuild test -project "Monarch-conversions.xcodeproj" -scheme "Monarch-conversions" -destination "platform=macOS"`

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| 1 | Domain types + formatter, pure tests | PR 1 | `RUN -only-testing:Monarch-conversionsTests/ImageFormatTests -only-testing:Monarch-conversionsTests/ConversionFormattingTests` | N/A — pure Foundation, app-unreferenced until PR 2 | Delete 3 new sources + 2 test files |
| 2 | Typed record, seed, store recovery, record views | PR 2 | `RUN -only-testing:Monarch-conversionsTests/ConversionSeedServiceTests` | Launch over old-schema store: 6 rows regenerate, strings unchanged | Revert 5 modified files; delete local store |
| 3 | Typed batch item, selection relocation, scene | PR 3 | `RUN -only-testing:Monarch-conversionsTests/BatchQueueItemTests` | Launch Convert scene: strings unchanged, selection toggles | Revert 4 modified files + 1 test file |

Source paths relative to nested `Monarch-conversions/`; tests in repo-root `Monarch-conversionsTests/`.

## Phase 1: Types + formatter (Unit 1, PR 1) — 1.1‖1.2 parallel, rest sequential

- [x] 1.1 RED: create `Monarch-conversionsTests/ImageFormatTests.swift` — six raw-value round-trips (PNG, JPG, WebP, AVIF, SVG, TIF); `rawValue: "BMP"` → nil; `init?(fileExtension:)` case-insensitive, `jpeg`→`.jpg`, `tiff`→`.tif`, unknown → nil; `PixelDimensions` holds 4096/2731 as `Int`. [CD1, CD2, CF4]
- [x] 1.2 RED: create `Monarch-conversionsTests/ConversionFormattingTests.swift` — `byteSize` exact: "684 KB", "412 KB", "96 KB", "420 KB", "1.2 MB", "2.8 MB", "4.1 MB"; `dimensions` "4096 × 2731" (U+00D7); `reduction` "-85%", "0%". [CF1, CF2, CF3]
- [x] 1.3 GREEN: create `Features/Conversions/Models/ImageFormat.swift` per D1 — explicit raw values, `init?(fileExtension:)`, no displayName API. [CD1, CF4]
- [x] 1.4 GREEN: create `Features/Conversions/Models/PixelDimensions.swift` — `let width, height: Int`; Equatable/Codable/Sendable. [CD2]
- [x] 1.5 GREEN: create `Features/Conversions/Views/ConversionFormatting.swift` per D2 — Foundation-only, base-1000: <1 MB integer KB, else one-decimal MB. [CF1–CF3]
- [x] 1.6 Unit-1 focused tests green; new files added to app/test targets.

## Phase 2: Record cluster (Unit 2, PR 2) — after Phase 1; sequential

- [x] 2.1 RED: create `Monarch-conversionsTests/ConversionSeedServiceTests.swift` — in-memory `ModelContainer`; seeding twice → exactly 6 records; hero-banner.png: `.png`→`.webp`, 4096×2731, `outputSizeBytes` formats to "684 KB", status working. [CD3, CD6, CF1]
- [x] 2.2 GREEN: modify `Features/Conversions/Models/ConversionRecord.swift` — `inputFormatRaw`/`outputFormatRaw` + computed `ImageFormat` (`?? .png`); `pixelWidth`/`pixelHeight` + computed `PixelDimensions`; `outputSizeBytes: Int64`; keep `statusRaw`. [CD3]
- [x] 2.3 GREEN: modify `Features/Conversions/Services/ConversionSeedService.swift` — six typed seeds reproducing today's exact strings; idempotent. [CD6]
- [x] 2.4 Modify `App/Monarch_conversionsApp.swift` — D6: on container failure delete `.store`/`-shm`/`-wal`, retry persistent once, in-memory last resort. [CD6]
- [x] 2.5 Modify `Features/Conversions/Views/ConversionsTableView.swift` + `ConversionDetailModalView.swift` — format at render via `ConversionFormatting`/`rawValue`; no stored strings. [CF5]
- [x] 2.6 Full suite green; launch over old store → rows regenerate, visible strings identical. [CD6, CF5]

## Phase 3: Batch cluster (Unit 3, PR 3) — needs only Phase 1; sequence after Phase 2 for clean chained diffs

- [x] 3.1 RED: create `Monarch-conversionsTests/BatchQueueItemTests.swift` — `reductionPercent`: 1000→150 = −85; zero original → 0; 1000→147 = −85 (rounding); nil target → nil; bytes behind 2.8 MB→420 KB = −85; no `isSelected` member. [CD4, CD5, CF3]
- [x] 3.2 GREEN: modify `Features/Conversions/Models/BatchQueueItem.swift` — `format`/`targetFormat: ImageFormat`, `dimensions: PixelDimensions`, `originalSizeBytes: Int64`, `targetSizeBytes: Int64?`, computed `reductionPercent: Int?`; drop `isSelected`. [CD4, CD5]
- [x] 3.3 Modify `Features/Conversions/Views/BatchQueueItemRow.swift` — add `let isSelected: Bool`; render via formatters; trailing with target: `"{targetFormat.rawValue} · {size} ({pct})"`; nil target renders EXACTLY `targetFormat.rawValue` alone (pinned D4 interim — no "·", size, or percent). [CD4, CF5]
- [x] 3.4 Modify `Features/Conversions/Views/BatchQueueView.swift` — pass `isSelected: selectedId == item.id`; delete per-row struct-copy hack. [CD4]
- [x] 3.5 Modify `Scenes/Convert/ConvertScene.swift` — typed mocks reproducing today's strings; keep `@State selectedId`; inspector strings via `ConversionFormatting`. [CF5]
- [x] 3.6 Full suite green; Convert scene strings identical ("4.1 MB", "420 KB (-85%)"); selection toggle leaves item values unchanged. [CD4, CF5]
