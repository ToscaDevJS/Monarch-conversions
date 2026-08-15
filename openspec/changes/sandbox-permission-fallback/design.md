# Design: App Sandbox Permission Fallback & Bookmark Management

## Component & Flow Architecture

```
[Conversion Request (sourceURL, settings)]
               │
               ▼
[Determine Target Output Directory]
   ├─ settings.outputDirectoryURL != nil ──► [Resolve Bookmark / Bracket Security-Scope] ──► [Write File]
   │
   └─ settings.outputDirectoryURL == nil (Same as Source)
               │
               ▼
   [Pre-flight: Is sourceURL parent writable?]
        ├─ YES ──► [Write to sourceURL parent directory]
        │
        └─ NO (Sandbox restriction) ──► [Fallback to ~/Downloads]
                                                │
                                                ▼
                                    [Flag fallback in ImageConversionResult / BatchItem]
                                                │
                                                ▼
                                    [BatchQueueItemRow displays fallback indicator]
```

## Data Structure Changes

1. `ImageConversionResult`:
```swift
public struct ImageConversionResult: Sendable {
    public let outputURL: URL
    public let outputByteSize: Int64
    public let duration: TimeInterval
    public let wasFallback: Bool
}
```

2. `BatchQueueItem`:
```swift
public var isFallbackDestination: Bool
```

3. `ImageConversionService`:
- Helper: `isWritable(directory: URL) -> Bool`
- Helper: `resolveFallbackDirectory() -> URL`

## Verification Plan
1. Unit tests in `ImageConversionServiceTests` testing:
   - Writable directory writing without fallback.
   - Non-writable directory routing to Downloads fallback.
   - `wasFallback` flag accuracy in `ImageConversionResult`.
2. Unit tests in `BatchQueueItemTests` verifying fallback badge state.
3. Full test suite validation via `xcodebuild` / Xcode tests.
