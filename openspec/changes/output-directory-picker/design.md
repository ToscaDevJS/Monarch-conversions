# Design: Output Destination Folder Picker

## Component Flow

```
[OutputSettingsView]
      │
      ├─► [Menu: Destination Folder ⌄]
      │      ├─ "Same as Source File" ──► settings.outputDirectoryURL = nil
      │      └─ "Choose Folder..." ─────► NSOpenPanel.canChooseDirectories = true
      │
      └─► Display selected folder path / "Same as Source"
```

## macOS NSOpenPanel Helper
Create `DirectoryPickerHelper` helper struct:
```swift
@MainActor
struct DirectoryPickerHelper {
    static func pickFolder() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Select Folder"
        return panel.runModal() == .OK ? panel.url : nil
    }
}
```

## Verification Plan
1. Unit tests in `OutputDirectoryPickerTests` verifying `ConversionSettings` values.
2. Build and run unit test suite via `xcodebuild test`.
