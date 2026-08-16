# Proposal: Reveal Converted File in Finder

## Problem
After an image batch conversion completes, users have no quick or direct way to locate the generated files on disk. If a fallback destination (such as `~/Downloads`) or a custom folder was used, users must manually navigate macOS Finder and search for the converted output file.

## Proposed Solution
1. **Output URL Tracking**: Add `outputFileURL: URL?` property to `BatchQueueItem` to store the exact path of successfully converted files returned by `ImageConversionResult.outputURL`.
2. **Reveal Action in UI**:
   - In `BatchQueueItemRow`, render an interactive "Reveal in Finder" action button (folder icon) when `status == .done` and `outputFileURL != nil`.
   - Add a context menu (`.contextMenu`) item "Reveal in Finder" on converted rows.
3. **Workspace Integration**: Invoke `NSWorkspace.shared.activateFileViewerSelecting([outputURL])` to open Finder and immediately highlight the converted file.
4. **Unit & UI Tests**: Add unit tests verifying `outputFileURL` assignment and UI tests verifying reveal control existence.

## Impact
Significantly improves workflow velocity and usability by providing instant one-click access to converted image files in Finder.
