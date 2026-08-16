# Design: Reveal Converted File in Finder

## Architecture & Flow

```
[BatchQueueItem (status: .done, outputFileURL: URL)]
                     │
                     ▼
             [BatchQueueItemRow]
         ┌───────────┴───────────┐
         ▼                       ▼
 [Quick Action Button]    [Context Menu Item]
 (SF Symbol: folder)      ("Reveal in Finder")
         │                       │
         └───────────┬───────────┘
                     ▼
 [NSWorkspace.shared.activateFileViewerSelecting([outputFileURL])]
                     │
                     ▼
 [macOS Finder opens with target file selected]
```

## Model Changes
In `BatchQueueItem.swift`:
```swift
public struct BatchQueueItem: Identifiable, Equatable, Sendable {
    ...
    public let outputFileURL: URL?
    ...
}
```

## UI Component Details
In `BatchQueueItemRow.swift`:
- When `item.status == .done` and `let outputURL = item.outputFileURL`:
  - Show a small circular / square button with icon `folder` or `arrow.up.forward.app`.
  - Add `.contextMenu` on the item button with action `Button("Reveal in Finder", systemImage: "folder")`.
  - Execute `NSWorkspace.shared.activateFileViewerSelecting([outputURL])`.

## Verification Plan
1. Unit tests in `BatchQueueItemTests` verifying `outputFileURL` serialization, comparison, and initialization.
2. Unit tests in `BatchQueueItemStatusTests` verifying `outputFileURL` is populated upon conversion.
3. UI tests in `BatchQueueStatusUITests` verifying row elements.
