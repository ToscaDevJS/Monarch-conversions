# Global Search & UI Actions Specification

## Functional Specs
1. **Search Behavior**:
   - Typing in `GlobalSearchBarView` performs case-insensitive substring matching against `fileName`, `fileId`, `project`, `inputFormat`, and `outputFormat`.
   - Pressing `⌘K` anywhere in the app focuses the `GlobalSearchBarView` text field.
2. **UI Button Actions**:
   - **Copy Name**: Places the selected file name onto `NSPasteboard.general`.
   - **Open Original**: Opens Finder selecting the original file or opens the default application for the file URL.
   - **ESC Key**: Dismisses `ConversionDetailModalView` when the Escape key is pressed.
