# Design: Real-Time Batch Queue Item Status Indicators

## Component & State Flow

```
[ConvertScene.processBatchConversion()]
           │
           ├─► items[i].status = .converting ──► [BatchQueueItemRow shows ProgressView]
           │
           └─► items[i].status = .done ────────► [BatchQueueItemRow shows ✓ Done badge]
```

## Data Structure
```swift
public enum BatchItemStatus: String, Sendable, Equatable, CaseIterable {
    case queued
    case converting
    case done
    case failed
}
```

## Verification Plan
1. Unit tests in `BatchQueueItemStatusTests` checking status initialization and mutations.
2. Build and run unit test suite via `xcodebuild test`.
