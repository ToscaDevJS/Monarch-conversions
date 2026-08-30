# Design: Orientation and Metadata Synchronization

## Architectural Decisions

### Decision 1: Post-Decode Metadata Adjustment
When `settings.preserveMetadata` is `true`, source properties are extracted via `CGImageSourceCopyPropertiesAtIndex`.
However, because the decoded `CGImage` may or may not undergo a physical pixel transformation depending on whether `CGImageSourceCreateThumbnailAtIndex(..., kCGImageSourceCreateThumbnailWithTransform: true)` is executed:
- If resized with transform: the orientation in the metadata dictionary must be overwritten to `1` (normal / top-left) for both `kCGImagePropertyOrientation` and inside any `{TIFF}` sub-dictionary (`kCGImagePropertyTIFFOrientation`).
- If not resized: `CGImageSourceCreateImageAtIndex` returns the untransformed pixels, so preserving the original `Orientation` tag is correct.

### Decision 2: Sanitizing Thumbnail Dictionaries
When copying properties, embedded thumbnail representations (such as `{MakerApple}` preview offsets, thumbnail dictionaries) could cause viewers to show an outdated thumbnail. We strip thumbnail-specific properties from `destinationProperties` prior to encoding.

## Sequence Diagram

```mermaid
sequenceDiagram
    autonumber
    actor Client
    participant Engine as ImageConversionService
    participant ImageIO as CGImageSource / CGImageDestination
    participant FileSys as Disk

    Client->>Engine: convert(sourceURL, settings)
    Engine->>ImageIO: CGImageSourceCreateWithURL(sourceURL)
    alt settings.preserveMetadata == true
        Engine->>ImageIO: CGImageSourceCopyPropertiesAtIndex(0)
        Engine->>Engine: Extract base properties (omit pixel width/height)
    end

    alt Has maxWidth / maxHeight (Resize)
        Engine->>ImageIO: CGImageSourceCreateThumbnailAtIndex(..., WithTransform: true)
        ImageIO-->>Engine: finalCGImage (Pixels rotated)
        alt settings.preserveMetadata == true
            Engine->>Engine: Override Orientation = 1 in destinationProperties & TIFF dict
        end
    else No Resize
        Engine->>ImageIO: CGImageSourceCreateImageAtIndex(0)
        ImageIO-->>Engine: finalCGImage (Raw pixels)
        Engine->>Engine: Keep original Orientation in destinationProperties
    end

    Engine->>ImageIO: CGImageDestinationAddImage(validDestination, finalCGImage, destinationProperties)
    Engine->>ImageIO: CGImageDestinationFinalize(validDestination)
    Engine->>FileSys: Write destination file
    Engine-->>Client: ImageConversionResult
```
