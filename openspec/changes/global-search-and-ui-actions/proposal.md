# Proposal: Global Search Bar & UI Button Actions

## Problem
1. **Search Unconnected**: `GlobalSearchBarView` accepts `@Binding var searchText`, but typing into the search bar does not filter `ConversionsTableView` records. Furthermore, pressing `⌘K` does not focus the search bar.
2. **Missing Actions**: Buttons in `ConversionDetailModalView` ("Copy name", "Open original") and `SquooshInspectorView` have empty action handlers (`Button {}`).
3. **Modal Close Shortcut**: The modal footer displays `"Press ESC to close"`, but pressing `ESC` does not trigger modal dismissal.

## Proposed Solution
1. **Global Search Integration**: Extend `TableFilterState` with a `searchText` field that matches record `fileName`, `fileId`, `project`, `inputFormat`, and `outputFormat`. Bind `GlobalSearchBarView` in `DashboardScene` directly to `ConversionsTableView`.
2. **`⌘K` Focus Shortcut**: Add `@FocusState` in `GlobalSearchBarView` triggered via `.keyboardShortcut("k", modifiers: .command)`.
3. **Functional Actions**:
   - `Copy name`: Copies filename to system clipboard (`NSPasteboard.general`).
   - `Open original`: Opens file or parent folder in macOS Finder (`NSWorkspace.shared`).
   - `ESC key`: Add `.onKeyPress(.escape)` or `.keyboardShortcut(.cancelAction)` in `ConversionDetailModalView`.
4. **Unit Tests**: Add `GlobalSearchAndActionsTests` validating search matching, pasteboard integration, and filter behavior.

## Impact
Delivers end-to-end global search capability across the app workspace and completes missing modal/inspector interactive button handlers.
