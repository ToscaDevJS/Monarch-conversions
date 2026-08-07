# Design: Real File Import

## Technical Approach

Both entry points resolve to `[URL]` and converge on one service: `.dropDestination(for: URL.self)` on `BatchDropzoneView` (drag) and an `NSOpenPanel` wrapper invoked through the existing `onBrowse` closure (fixing the dead wiring at `ConvertScene.swift:54`). `ImageImportService.importFiles(at:existingCount:)` validates each URL and reads metadata via `CGImageSourceCreateWithURL` (header streaming — never loads full bytes), returning one per-file outcome: an accepted `BatchQueueItem` or a typed `ImportRejection`. ImageIO and AppKit imports are confined to `Features/Conversions/Services/` (architecture invariant 3). Queue starts empty (mocks removed).

## Architecture Decisions

### Decision: Rejection feedback surface — inline dismissible section

**Choice**: A new `ImportRejectionListView` rendered between the dropzone and the queue: header `REJECTED (N)` with a `Dismiss` button, one row per rejected file (name + human-readable reason).
**Alternatives considered**: (a) Toast/overlay — transient and miss-able (defeats the "visible feedback" mandate), stacks poorly at up to 50 rejections, needs new overlay infrastructure; (b) modal alert — interrupts drag flow, unreadable when aggregating many reasons.
**Rationale**: Persistent until dismissed (accessibility: no timed disappearing content), scales to many files, reuses the queue's row visual language and MonarchUI tokens, and is plain testable `@State`.

**State flow**: rejections live in `ConvertScene` as `@State private var rejections: [ImportRejection]` — ephemeral, in-memory, never persisted. Each import **replaces** the previous list (latest batch's feedback wins). Dismissal: header button sets it to `[]`. Reason → copy mapping lives in `ConversionFormatting.rejectionMessage(_:)` (existing display-string seam), keeping models pure.

### Decision: Service is a pure, limit-configurable seam

**Choice**: `ImageImportService` struct with injectable `maxFileSizeBytes` (default 100 MB) and `maxBatchCount` (default 50); `nonisolated` async method so work hops off the main actor.
**Rationale**: Tests inject tiny limits (e.g. 1 KB) to trigger `fileTooLarge` with few-KB fixtures — no 100 MB fixture. Strict TDD needs deterministic per-file outcomes in input order.

### Decision: Allow-list ownership

**Choice**: Allow-list (png, jpg, webp, avif, tif, heic, jpeg2000, jpegXL — SVG excluded) lives in the service as `allowedFormats` plus `allowedContentTypes: [UTType]` for `NSOpenPanel`, resolved defensively (`compactMap` over identifier strings for avif/jp2/jxl).
**Alternatives considered**: `importSupported` property on `ImageFormat`.
**Rationale**: Import viability is ImageIO capability knowledge; putting it on the domain enum leaks SDK concerns into Models.

### Decision: Per-file validation order

extension allow-list → byte size (`resourceValues`) → readability (`CGImageSource` yields pixel width/height) → capacity (`existingCount` + accepted so far < 50). Capacity checked **last** and only for otherwise-valid files, so users learn the more actionable specific reason first; invalid files never consume slots. Reads bracketed by `startAccessingSecurityScopedResource()` (no-op unsandboxed; forward-compat).

## Data Flow

    Drop URLs ──┐                                      ┌─→ items += accepted (append)
                ├─→ ConvertScene.handleImport([URL]) ──┤
    NSOpenPanel ┘        │ Task { await }              └─→ rejections = rejected (replace)
    (ImageFilePicker)    ▼
                ImageImportService.importFiles → [ImportOutcome] (input order)

## File Changes

| File (under `Monarch-conversions/`) | Action | Description |
|---|---|---|
| `Features/Conversions/Models/ImageFormat.swift` | Modify | Add `.heic("HEIC")`, `.jpeg2000("JP2")`, `.jpegXL("JXL")`; extend `init?(fileExtension:)` (heic/heif, jp2/j2k/jpf, jxl) |
| `Features/Conversions/Models/BatchQueueItem.swift` | Modify | `targetFormat: ImageFormat?` (init default `nil`); add `Equatable` |
| `Features/Conversions/Models/ImportRejection.swift` | Create | `ImportRejection` (Identifiable) with nested `Reason` enum |
| `Features/Conversions/Models/ImportOutcome.swift` | Create | Per-file `accepted(BatchQueueItem)` / `rejected(ImportRejection)` |
| `Features/Conversions/Services/ImageImportService.swift` | Create | Validation + ImageIO metadata pipeline; owns allow-list and limits |
| `Features/Conversions/Services/ImageFilePicker.swift` | Create | `@MainActor` NSOpenPanel wrapper (AppKit confined); returns `[URL]` |
| `Features/Conversions/Views/ImportRejectionListView.swift` | Create | Rejection feedback section (header + rows + Dismiss) |
| `Features/Conversions/Views/ConversionFormatting.swift` | Modify | `rejectionMessage(_:)` — Reason → user copy |
| `Features/Conversions/Views/BatchDropzoneView.swift` | Modify | `.dropDestination(for: URL.self)`, `onDropFiles` closure, `isTargeted` styling |
| `Features/Conversions/Views/BatchQueueItemRow.swift` | Modify | `trailingText` shows "No target" placeholder when `targetFormat == nil` |
| `Scenes/Convert/ConvertScene.swift` | Modify | Empty initial queue; wire `onBrowse`/drop into `handleImport`; `rejections` state; inspector strings drop mock fallbacks ("No file selected" / "NO TARGET" / "—") |

## Interfaces / Contracts

```swift
public struct ImportRejection: Identifiable, Equatable, Sendable {
    public enum Reason: Equatable, Sendable {
        case unsupportedType(fileExtension: String)
        case fileTooLarge(sizeBytes: Int64, limitBytes: Int64)
        case batchLimitExceeded(limit: Int)
        case unreadable
    }
    public let id: UUID
    public let fileName: String
    public let reason: Reason
}

public enum ImportOutcome: Equatable, Sendable {
    case accepted(BatchQueueItem)
    case rejected(ImportRejection)
}

public struct ImageImportService: Sendable {
    public var maxFileSizeBytes: Int64  // default 100 MB
    public var maxBatchCount: Int       // default 50
    public nonisolated func importFiles(at urls: [URL], existingCount: Int) async -> [ImportOutcome]
}
```

Accepted items: `name` = `lastPathComponent`, `format` from extension, `dimensions` from ImageIO pixel width/height, `originalSizeBytes` from resource values, `targetFormat`/`targetSizeBytes` = `nil`.

## Testing Strategy

| Layer | What to Test | Approach |
|---|---|---|
| Unit (RED-first) | `ImageFormat` new cases + extension mapping; `BatchQueueItem` optional target; `rejectionMessage` copy | Swift Testing `@Suite`/`#expect` |
| Unit | `ImageImportService`: acceptance per fixture format with real metadata; each `Reason`; input-order preservation; non-abort on per-file failure; `existingCount` capacity math | Fixtures + injected tiny limits (`maxFileSizeBytes: 1_000`, `maxBatchCount: 2`) |
| Manual | Drop + Browse end-to-end, `isTargeted` highlight, dismiss flow | Run app |

**Fixture plan** (`Monarch-conversionsTests/Fixtures/`, each < 5 KB, real binaries): png, jpg, tif, heic, jp2 (generate via `sips`); webp, avif, jxl (sourced minimal samples — no system encoder); `sample.svg` and `corrupt.png` (text bytes) for rejection paths. Binary fixtures stay outside the authored-line review count.

## Threat Matrix

N/A — no routing, shell, subprocess, VCS/PR automation, executable-file classification, or process-integration boundary. Import classification gates decoding only; nothing is executed.

## Migration / Rollout

No migration. Enum cases are additive (`ConversionRecord` stores raw strings unchanged); queue is in-memory.

## Open Questions

- [ ] None blocking. JXL fixture must be sourced (ImageIO decodes but cannot encode JXL); if unattainable, flag the jxl acceptance test early in apply.
