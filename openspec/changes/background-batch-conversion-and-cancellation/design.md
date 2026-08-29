# Design: Background Batch Conversion, Cancellation Handle & Error Diagnostics

## Architecture

```
[UI Trigger (Convert)]
        │
        ▼
[Task.detached(priority: .userInitiated)]
        │
        ├─ Check Task.isCancelled ──YES──► Terminate
        │
        ▼
[MainActor.run] ── Fetch next .queued item info & set status = .converting
        │
        ▼
[Background Thread] ── ImageConversionService.convert(...)
        │
        ├─ SUCCESS ──► [MainActor.run] Update item to .done & insert ConversionRecord
        │
        └─ FAILURE ──► [MainActor.run] Update item to .failed & assign errorMessage
        │
        ▼
[Check Task.isCancelled] ── Loop next item
        │
        ▼
[MainActor.run] ── Save ModelContext & reset isProcessing = false
```

### Data Structures

In `BatchQueueItem.swift`:
```swift
public var errorMessage: String? = nil
```

### UI Handlers

In `ConvertScene.swift`:
- `conversionTask: Task<Void, Never>?`
- `cancelConversion()`
- Passed `onCancel: { cancelConversion() }` to `BatchStatusFooterView`.
