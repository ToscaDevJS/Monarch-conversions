# Design: Resilient ModelContainer Initialization & Store Preservation

## Component Architecture

A new static factory struct `ModelContainerFactory` in `Core/Storage/ModelContainerFactory.swift`:

```swift
public struct ModelContainerFactory {
    public static func createContainer(
        schema: Schema = Schema([ConversionRecord.self]),
        storeURL: URL? = nil,
        isStoredInMemoryOnly: Bool = false
    ) -> ModelContainer
}
```

### Recovery Flow

```
[Attempt Persistent ModelContainer(url)]
            │
            ├─ SUCCESS ──► Return container
            │
            └─ FAILURE (Error caught)
                  │
                  ▼
         [Back Up Existing Store Files]
         (move .store, -wal, -shm to .corrupt-{timestamp}.bak)
                  │
                  ▼
         [Retry Persistent ModelContainer]
                  │
                  ├─ SUCCESS ──► Return fresh container
                  │
                  └─ FAILURE (Error caught)
                        │
                        ▼
               [Create In-Memory ModelContainer]
                        │
                        ▼
               Return in-memory container (NO fatalError)
```

## Testing Strategy (`ModelContainerFactoryTests.swift`)

1. **Standard Creation**: Verify container initializes normally in memory and on disk.
2. **Corrupted Store Recovery (Strict TDD Red-Green)**: Write corrupt sentinel data (`"CORRUPTED_SQLITE_BYTES"`) to a store path. Invoke factory. Assert:
   - A backup file `.bak` exists and contains `"CORRUPTED_SQLITE_BYTES"`.
   - The returned `ModelContainer` works (can insert and query a `ConversionRecord`).
3. **In-Memory Degradation**: Verify that when pointed at an invalid/unwritable path where persistent recovery is impossible, it returns a functioning in-memory container without raising fatal exceptions.
