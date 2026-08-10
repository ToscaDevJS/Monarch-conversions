# Design: Real Image Preview in Squoosh Inspector

## Architecture & Data Flow

```
[BatchQueueItem (fileURL: URL?)] ──► [ConvertScene]
                                         │
                                         ▼
                      [SquooshInspectorView(imageURL:)]
                                         │
                                         ▼
                           [NSImage(contentsOf: url)]
                                   │         │
                           Original         Optimized Preview
```

## Implementation Strategy
- `SquooshInspectorView` gains an optional `imageURL: URL?` parameter.
- When `imageURL` points to a valid file, `NSImage(contentsOf: imageURL)` is loaded and displayed using `.resizable().scaledToFit()`.
- When `imageURL` is nil or invalid, elegant fallback placeholders are displayed.

## Verification Plan
1. Unit test suite in `SquooshInspectorViewTests` checking URL binding and fallback rendering.
2. Build and run unit test suite via `xcodebuild test`.
