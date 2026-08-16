# Design: Realtime Connected Batch Status Footer

## Architecture & Layout

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│ [● Engine: ImageIO] │ [3 files · 4.2 MB] │ [Target: WEBP 85%] │ [📁 Downloads] │ [✓ 3 done (68% saved)] │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## Component Breakdown

1. **`BatchStatusFooterView.swift`**:
   - Replaces `TelemetryFooterView` and `StatusFooterView`.
   - Properties:
     - `items: [BatchQueueItem]`
     - `settings: ConversionSettings`
     - `isProcessing: Bool`
   - Computed properties:
     - `totalOriginalBytes: Int64`: Sum of `item.originalSizeBytes`.
     - `totalOutputBytes: Int64`: Sum of `item.targetSizeBytes` for `.done` items.
     - `doneCount: Int`: Count of `.done` items.
     - `failedCount: Int`: Count of `.failed` items.
     - `convertingIndex: Int`: Current index being processed.
     - `totalReductionPct: Int?`: Aggregated reduction percentage.

2. **Destination Folder Click-to-Reveal**:
   - If `settings.outputDirectoryURL` is set, displays folder name and clicking reveals folder with `NSWorkspace.shared.open(url)`.
   - If nil, displays `"Same as Source / Downloads"`.
