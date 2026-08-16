# Design: Keyboard Shortcuts & Native macOS Menu Bar Commands

## Architecture

```
                                  [ macOS User Input ]
                                           │
         ┌─────────────────────────────────┼─────────────────────────────────┐
         ▼                                 ▼                                 ▼
   [ Menu Bar Items ]              [ Global Shortcuts ]             [ Scene Shortcuts ]
   File -> Import (⌘O)             ⌘1 -> Studio                     ⌘O -> Browse Files
   File -> Start Batch (⌘R)        ⌘2 -> Convert                    ⌘R / ⌘↵ -> Start Batch
   File -> Clear Queue (⌘K)        ⌘3 -> Settings                   ⌘⌫ -> Delete Selected Item
   View -> Scenes (⌘1..3)                                           ⌘K -> Clear Queue
```

## Component Updates

1. **`ConvertScene.swift`**:
   - Hidden or active button with `.keyboardShortcut("o", modifiers: .command)` triggering `ImageFilePicker.pickFiles()`.
   - Hidden or active button with `.keyboardShortcut("r", modifiers: .command)` and `.keyboardShortcut(.return, modifiers: .command)` triggering `processBatchConversion()`.
   - Hidden button with `.keyboardShortcut(.delete, modifiers: .command)` removing `selectedId`.
   - Hidden button with `.keyboardShortcut("k", modifiers: .command)` invoking `onClearAll`.

2. **`RootView.swift`**:
   - Background buttons with `.keyboardShortcut("1", modifiers: .command)`, `⌘2`, `⌘3` switching `router.navigateTo(tab)`.

3. **`Monarch_conversionsApp.swift`**:
   - `.commands` group defining File and View menu entries for macOS Menu Bar integration.
