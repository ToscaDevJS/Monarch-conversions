# Design: SVG Output Exclusion & Comparison Slider Real Output URL

## Architecture Changes

### 1. `ImageFormat.outputEligibleCases`
In `Features/Conversions/Models/ImageFormat.swift`:
```swift
public nonisolated static var outputEligibleCases: [ImageFormat] {
    allCases.filter { $0 != .webp && $0 != .jpegXL && $0 != .dng && $0 != .svg }
}
```

### 2. `SquooshInspectorView` Dual URL Support
In `Features/Conversions/Views/SquooshInspectorView.swift`:
- Properties:
  ```swift
  var imageURL: URL? = nil
  var outputImageURL: URL? = nil
  ```
- Image Loaders:
  ```swift
  private var loadedOriginalImage: NSImage? {
      guard let imageURL = imageURL else { return nil }
      return NSImage(contentsOf: imageURL)
  }

  private var loadedOutputImage: NSImage? {
      guard let outputImageURL = outputImageURL else { return loadedOriginalImage }
      return NSImage(contentsOf: outputImageURL)
  }
  ```
- Right pane loads `loadedOutputImage` with dynamic label based on `targetFormatText`.
- Left pane loads `loadedOriginalImage`.

### 3. `ConvertScene` Wiring
In `Scenes/Convert/ConvertScene.swift`:
```swift
SquooshInspectorView(
    fileName: selectedItem?.name ?? "No file selected",
    originalSizeText: originalSizeText,
    targetFormatText: targetFormatText,
    targetSizeText: targetSizeText,
    imageURL: selectedItem?.fileURL,
    outputImageURL: selectedItem?.outputFileURL
)
```

## Testing Strategy

1. `ImageFormatTests.swift`: Add `#expect(!ImageFormat.outputEligibleCases.contains(.svg))`.
2. `SquooshInspectorViewTests.swift`: Add test verifying `outputImageURL` storage and property binding.
