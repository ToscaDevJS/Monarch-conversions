# Squoosh Inspector Preview Specification

## Functional Specs
1. **Real Image Rendering**:
   - `SquooshInspectorView` accepts `imageURL: URL?`.
   - When `imageURL` is valid, `NSImage` is loaded and rendered within both clipped sides of the interactive split-screen slider.
   - When `imageURL` is nil or cannot be loaded into an `NSImage`, a placeholder badge is displayed gracefully.
