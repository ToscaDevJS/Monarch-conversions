# Design: Global Search Bar & UI Button Actions

## Architecture & Data Flow

```
[GlobalSearchBarView (@FocusState, ⌘K)] ──► [searchText (@State in DashboardScene)]
                                                       │
                                                       ▼
[ConversionsTableView(searchText:)] ──────► [TableFilterState(searchText:)] ──► [Filtered Table Rows]
```

## Action System Integration

1. **`NSPasteboard`**:
   - `NSPasteboard.general.clearContents()`
   - `NSPasteboard.general.setString(name, forType: .string)`

2. **`NSWorkspace`**:
   - `NSWorkspace.shared.selectFile(path, inFileViewerRootedAtPath: "")` or `NSWorkspace.shared.open(url)`

3. **ESC Key Modal Dismissal**:
   - Hidden button with `.keyboardShortcut(.escape, modifiers: [])` calling `onClose()`.

## Verification Plan
1. Unit tests in `GlobalSearchAndActionsTests` verifying `TableFilterState` substring query matching.
2. `xcodebuild test` execution.
