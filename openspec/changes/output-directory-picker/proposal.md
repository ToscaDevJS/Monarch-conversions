# Proposal: Output Destination Folder Picker

## Problem
In `OutputSettingsView`, users cannot customize where converted images are saved. They are automatically saved in the same directory as the source file with a `_converted` suffix.

## Proposed Solution
1. **Directory Picker Control**: Add a **Destination Folder** picker box in `OutputSettingsView` allowing users to select a custom output directory via `NSOpenPanel` or reset to "Same as Source".
2. **Path Persistence**: Store selected directory in `ConversionSettings.outputDirectoryURL`.
3. **Unit Tests**: Add `OutputDirectoryPickerTests.swift` testing setting updates and default fallbacks.

## Impact
Provides macOS power-users full control over output directory destination paths.
