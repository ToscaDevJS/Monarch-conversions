# Design: Prevent Batch Duplicate Conversions

## Flow Architecture

In `ConvertScene.swift`:

```
[Trigger Convert Button]
          │
          ▼
   isProcessing? ──YES──► Return immediately
          │ NO
          ▼
   Find items with status == .queued
          │
          ├─ None found ──► Return immediately
          │
          └─ Found pending items
                  │
                  ▼
          Set isProcessing = true
                  │
                  ▼
          For each pending item id:
              Find current item index in `items`
              If item.status != .queued, continue
              Convert item -> Update to .done -> Insert ConversionRecord
                  │
                  ▼
          Save modelContext -> Set isProcessing = false
```

### Protection on Mutations

```swift
private func clearQueue() {
    guard !isProcessing else { return }
    items.removeAll()
    selectedId = nil
    rejections.removeAll()
}

private func deleteSelectedItem() {
    guard !isProcessing else { return }
    guard let currentId = selectedId,
          let index = items.firstIndex(where: { $0.id == currentId }) else { return }
    items.remove(at: index)
    selectedId = items.first?.id
}
```

## Testing Strategy (`BatchQueueConversionTests.swift`)

1. **Filtering Test**: Assert that a helper filtering `items.filter { $0.status == .queued }` isolates only pending items.
2. **SwiftData Deduplication Test**: Simulate a batch run followed by a second batch run with identical items, verifying that the record count in `ModelContext` strictly matches the number of unique items without duplication.
