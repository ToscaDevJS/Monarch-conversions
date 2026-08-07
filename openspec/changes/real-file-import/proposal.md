# Proposal: Real File Import

## Intent

The Convert queue is fully mocked: `ConvertScene` seeds 4 hardcoded `BatchQueueItem`s, the dropzone accepts no drops, and the Browse button is dead (`ConvertScene.swift:54` never passes `onBrowse`). Users cannot get a real file into the app. Make import real — drag-and-drop and Browse both produce typed `BatchQueueItem`s from actual files — unblocking the conversion engine (roadmap step 3).

## Scope

### In Scope
- `.dropDestination(for: URL.self)` on `BatchDropzoneView`; `NSOpenPanel` Browse wired through the existing `onBrowse` closure (fixes the dead wiring).
- New `Features/Conversions/Services/ImageImportService.swift`: one `[URL] → [BatchQueueItem]` pipeline using ImageIO (`CGImageSourceCreateWithURL`) for format, dimensions, byte size; shared by both entry points.
- Enforce advertised limits: 50 files per batch, 100 MB per file (dropzone copy already promises them). Per-file failures skip, never abort the batch.
- Visible rejection feedback: every rejected file (over 100 MB, beyond the 50-file limit, unsupported type, unreadable) shows the user a visible explanation (toast or inline row — exact surface chosen in sdd-design).
- `ImageFormat` gains `.heic`, `.jpeg2000`, `.jpegXL`; `BatchQueueItem.targetFormat` becomes optional.
- Remove the hardcoded mock queue; empty queue shows the dropzone.
- Security-scoped resource bracketing (no-op unsandboxed; forward-compat).
- Swift Testing suite with small real fixture images (TDD).

### Out of Scope
- Conversion engine; persisting queue items to `ConversionRecord` (queue stays in-memory, disconnected from SwiftData).
- WebP and JPEG XL encoding (decode-only on target — import-only, never offered as output); `OutputSettingsView` stays mock.
- SVG and HEICS import; App Sandbox/entitlements.

## Decisions

1. **ImageFormat coverage** (user decision): full decode coverage now — add `.heic`, `.jpeg2000`, and `.jpegXL`. HEIC is the default iPhone camera format; all three are ImageIO-decodable on target. Platform nuance: JPEG 2000 is also ImageIO-encodable on target; JPEG XL is decode-only, so like WebP it is import-only and must never be offered as an output format. v1 allow-list: png, jpg, webp, avif, tif, heic, jpeg2000, jpegXL.
2. **SVG**: excluded from the v1 allow-list. ImageIO cannot decode vector SVG; mirrors the defer-first WebP-encoding pattern. `.svg` stays in the enum for existing Dashboard records; a non-ImageIO path is future work.
3. **targetFormat**: becomes `ImageFormat?`. Any default (e.g. WebP) fabricates a choice the user never made — and WebP encoding is deferred, so it would promise the impossible. Rows show a "no target yet" placeholder; target size/reduction stay empty until step 3.
4. **Rejected-file feedback** (user decision): visible feedback is required for v1, not silent skip. Every rejection (over 100 MB, beyond the 50-file limit, unsupported type, unreadable) produces a visible explanation; toast vs inline row is chosen in sdd-design.

## Capabilities

### New Capabilities
- `file-import`: importing real image files into the Convert queue via drag-drop and Browse — allowed types, batch limits, metadata extraction, per-file rejection with visible user feedback.

### Modified Capabilities
- `conversion-domain`: `ImageFormat` supported set gains HEIC, JPEG 2000, and JPEG XL; `BatchQueueItem.targetFormat` becomes optional.

## Approach

Exploration approach 1: `URL` is already `Transferable`, so drop and `NSOpenPanel` converge on one `[URL]` pipeline. `CGImageSourceCreateWithURL` reads headers without loading whole files (matters at 50 × 100 MB). The service confines `ImageIO`/`AppKit` imports per architecture invariant 3.

## Affected Areas

| Area | Impact |
|---|---|
| `Features/Conversions/Services/ImageImportService.swift` | New |
| `Features/Conversions/Views/BatchDropzoneView.swift` | Modified — drop destination |
| `Scenes/Convert/ConvertScene.swift` | Modified — wire `onBrowse`, remove mocks |
| `Features/Conversions/Models/ImageFormat.swift`, `BatchQueueItem.swift` | Modified |
| `BatchQueueItemRow` / queue views | Modified — optional-target display |
| `Monarch-conversionsTests/` | New fixtures + import suite |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Optional `targetFormat` ripples through views | Med | Delta spec defines placeholder display |
| Fixture images bloat review diff | Med | Few-KB fixtures; binary, outside authored-line count |
| >400-line review budget | Med | sdd-tasks slices: domain → service+tests → UI wiring |
| Unreadable/non-file drops | Low | Per-file skip with visible rejection feedback, tested |

## Rollback Plan

Revert the change commits. Queue is in-memory (no persistence change); the new format cases are additive to the enum, safe to revert before any `ConversionRecord` uses them. Mock queue is restorable from git history.

## Dependencies

- Roadmap step 1 (`typed-conversion-domain`) — merged.

## Success Criteria

- [ ] Dropping or browsing real png/jpg/webp/avif/tif/heic/jpeg2000/jpegXL files enqueues typed items with real name, format, dimensions, byte size.
- [ ] Browse opens `NSOpenPanel` (dead wiring fixed).
- [ ] Files beyond 50, over 100 MB, unsupported (incl. SVG), or unreadable are skipped without aborting the batch, and each rejection shows a visible explanation.
- [ ] Swift Testing suite passes; queue remains disconnected from SwiftData.
