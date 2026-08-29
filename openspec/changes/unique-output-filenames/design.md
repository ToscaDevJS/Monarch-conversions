# Design: Unique Output Filenames on Collision

## Architecture & Flow

In `ImageConversionService.swift`, the resolution of destination URLs is updated to check file existence:

```
[Candidate Directory + Base Name + Target Ext]
                  │
                  ▼
   Does {name}_converted.{ext} exist?
         ├─ NO  ──► Use {name}_converted.{ext}
         │
         └─ YES ──► Loop counter = 1, 2, 3...
                    Find first {name}_converted-{counter}.{ext} that does NOT exist
```

### Helper Method

```swift
static func uniqueDestinationURL(in directory: URL, baseName: String, ext: String) -> URL {
    let initialURL = directory.appendingPathComponent("\(baseName)_converted.\(ext)")
    guard FileManager.default.fileExists(atPath: initialURL.path) else {
        return initialURL
    }

    var counter = 1
    while true {
        let candidateURL = directory.appendingPathComponent("\(baseName)_converted-\(counter).\(ext)")
        if !FileManager.default.fileExists(atPath: candidateURL.path) {
            return candidateURL
        }
        counter += 1
    }
}
```

This helper is utilized for:
1. `resolvedDirectory` destination URL creation.
2. `fallbackDir` (`Downloads`) destination URL creation.
3. `tempURL` (`temporaryDirectory`) destination URL creation.

## Testing Strategy (`ImageConversionServiceTests.swift`)

1. Test standard conversion when no collision occurs.
2. Test single collision: pre-write a sentinel file at `{name}_converted.jpg` and verify output is written to `{name}_converted-1.jpg` without mutating the sentinel file.
3. Test double collision: pre-write `{name}_converted.jpg` and `{name}_converted-1.jpg` and verify output is written to `{name}_converted-2.jpg`.
