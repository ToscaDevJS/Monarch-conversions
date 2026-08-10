# Proposal: Real Image Preview in Squoosh Inspector

## Problem
In `SquooshInspectorView`, the split-screen visual comparison slider currently displays static placeholder text blocks (`Text("ORIGINAL (PNG)")` and `Text("WEBP OPTIMIZED")`) instead of loading and rendering the actual image file selected in `ConvertScene`.

## Proposed Solution
1. **Real Image Loading**: Pass `fileURL: URL?` from `ConvertScene.selectedItem` to `SquooshInspectorView`.
2. **Asynchronous Image Preview**: Asynchronously load and cache `NSImage` from `fileURL`, rendering the actual image content on both sides of the comparison slider with fallback placeholders for unreadable or non-existent files.
3. **Unit Tests**: Add `SquooshInspectorViewTests` validating image loading logic and URL binding.

## Impact
Provides full visual fidelity when comparing original and converted image files in the Squoosh-inspired inspector tool.
