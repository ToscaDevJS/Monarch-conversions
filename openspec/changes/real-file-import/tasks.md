# Tasks: Real File Import

`XCT` = `xcodebuild test -project "Monarch-conversions.xcodeproj" -scheme "Monarch-conversions" -destination "platform=macOS"`.
Tags: FI-1 supported types, FI-2 unified pipeline, FI-3 metadata, FI-4 limits, FI-5 failure isolation, FI-6 rejection feedback, FI-7 empty queue, CD-1 ImageFormat enum, CD-2 typed queue item.

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~650 authored (U1 ~150, U2 ~300, U3 ~110, U4 ~130); binary fixtures (jxl, webp, avif, png, jpg, tif, heic, jp2, corrupt.png) excluded from authored count |
| 400-line budget risk | High |
| Chained PRs recommended | Yes |
| Suggested split | PR 1 → PR 2 → PR 3 → PR 4 |
| Delivery strategy | ask-on-risk |
| Chain strategy | pending |

Decision needed before apply: Yes
Chained PRs recommended: Yes
Chain strategy: pending
400-line budget risk: High

Feature-branch-chain bases: PR 1 → tracker, PR 2 → PR 1, PR 3 → PR 2, PR 4 → PR 3. Stacked-to-main also viable: units 1–3 are additive/inert; FI-2/6/7 complete only when PR 4 lands.

### Suggested Work Units

| Unit | Goal | Likely PR | Focused test command | Runtime harness | Rollback boundary |
|------|------|-----------|----------------------|-----------------|-------------------|
| 1 | Domain formats + optional target (CD-1, CD-2) | PR 1 | `XCT -only-testing:Monarch-conversionsTests/ImageFormatTests -only-testing:Monarch-conversionsTests/BatchQueueItemTests` | N/A — pure domain | Revert ImageFormat, BatchQueueItem, BatchQueueItemRow, tests |
| 2 | Import service + fixtures (FI-1,3,4,5) | PR 2 | `XCT -only-testing:Monarch-conversionsTests/ImageImportServiceTests` | N/A — unreferenced by UI until PR 4 | Delete service, outcome models, tests, fixtures |
| 3 | Rejection copy + view (FI-6) | PR 3 | `XCT -only-testing:Monarch-conversionsTests/ConversionFormattingTests` | N/A — view unmounted until PR 4 | Delete ImportRejectionListView; revert ConversionFormatting |
| 4 | Scene wiring: drop, Browse, empty queue (FI-2,6,7) | PR 4 | `XCT` (full) | Run app: drop mixed batch, Browse, dismiss rejections | Revert ConvertScene, BatchDropzoneView; delete ImageFilePicker |

Order: 1 → 2 → 3 → 4. Parallelism: Unit 3 may start once 2.2 lands; everything else sequential. Threat matrix: N/A per design.

## Phase 1: Domain (Unit 1)

- [x] 1.1 RED: extend `Monarch-conversionsTests/ImageFormatTests.swift` — raw-value round-trip for heic/jp2/jxl; `init?(fileExtension:)` maps heic/heif, jp2/j2k/jpf, jxl; unknown raw value safe; output-eligible set excludes webp and jpegXL [CD-1]
- [x] 1.2 RED: extend `BatchQueueItemTests.swift` — `targetFormat` optional, default nil; `Equatable` [CD-2]
- [x] 1.3 GREEN: `Features/Conversions/Models/ImageFormat.swift` — add `.heic("HEIC")`, `.jpeg2000("JP2")`, `.jpegXL("JXL")` with doc comments stating jpegXL (like webp) is decode-only/import-only and must never be offered as an output format (guards future `allCases` output pickers) [CD-1]
- [x] 1.4 GREEN: `BatchQueueItem.swift` — `targetFormat: ImageFormat?` default nil; add `Equatable` [CD-2]
- [x] 1.5 GREEN: `BatchQueueItemRow.swift` `trailingText` shows "No target" placeholder when nil; minimal call-site fixes so target builds [CD-2]

## Phase 2: Import Service (Unit 2)

- [x] 2.1 FIRST — fixtures (`Monarch-conversionsTests/Fixtures/`, real binaries < 5 KB): source minimal jxl NOW (ImageIO/sips cannot encode it — a missing jxl must block at apply start), plus webp and avif samples; generate 400×300 png, jpg, tif, heic, jp2 via `sips`; author `sample.svg` and `corrupt.png` (text bytes); add all to test target [FI-1]
- [x] 2.2 Create `Features/Conversions/Models/ImportRejection.swift` (nested `Reason`) and `ImportOutcome.swift` per design contract [FI-5, FI-6]
- [x] 2.3 RED: create `ImageImportServiceTests.swift` (`@Suite`/`#expect`) — acceptance per fixture with real metadata [FI-1]; png reports 400×300 and exact byte size [FI-3]; svg and unknown extension rejected [FI-1]; `fileTooLarge` via `maxFileSizeBytes: 1_000` [FI-4]; `batchLimitExceeded` via `maxBatchCount: 2` with `existingCount` math, capacity checked last, invalid files consume no slots [FI-4]; corrupt file skipped, valid files enqueue, input order preserved [FI-5]
- [x] 2.4 GREEN: create `Features/Conversions/Services/ImageImportService.swift` — allow-list + `allowedContentTypes`, validation order extension → size → readability → capacity, `CGImageSourceCreateWithURL` header-only metadata, security-scoped access brackets [FI-1..FI-5]

## Phase 3: Rejection Feedback (Unit 3)

- [x] 3.1 RED: extend `ConversionFormattingTests.swift` — `rejectionMessage(_:)` distinct copy for all four `Reason` cases [FI-6]
- [x] 3.2 GREEN: add `rejectionMessage(_:)` to `ConversionFormatting.swift` [FI-6]
- [x] 3.3 Create `Features/Conversions/Views/ImportRejectionListView.swift` — "REJECTED (N)" header, Dismiss button, one row per file (name + reason), MonarchUI tokens [FI-6]

## Phase 4: Scene Wiring (Unit 4)

- [x] 4.1 Create `Features/Conversions/Services/ImageFilePicker.swift` — `@MainActor` NSOpenPanel wrapper scoped to `allowedContentTypes` [FI-2]
- [x] 4.2 `BatchDropzoneView.swift` — `.dropDestination(for: URL.self)`, `onDropFiles` closure, `isTargeted` styling [FI-2]
- [x] 4.3 `Scenes/Convert/ConvertScene.swift` — start empty (delete mocks); `handleImport([URL])` appends accepted, replaces `rejections` `@State`; wire dead `onBrowse` (line 54) and drop; mount ImportRejectionListView between dropzone and queue; inspector strings drop mock fallbacks [FI-2, FI-6, FI-7]
- [x] 4.4 Verify: full `XCT`; manual harness — mixed batch (oversized, unsupported, corrupt) yields three explanations, Browse equivalent to drop, dropzone visible when queue empty [FI-2, FI-6, FI-7]
