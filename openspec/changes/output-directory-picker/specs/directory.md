# Output Directory Specification

## Functional Specs
1. **Destination Selection**:
   - `OutputSettingsView` includes a destination dropdown control.
   - Selecting "Same as Source File" clears `settings.outputDirectoryURL`.
   - Selecting "Choose Folder..." opens `NSOpenPanel` for directory selection.
   - Selected folder path label is displayed concisely (e.g. `Downloads` or `Original`).
