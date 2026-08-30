# Proposal: Fix EXIF Orientation Double Rotation & Metadata Synchronization

## Problem
When converting and resizing images with EXIF orientation (e.g. vertical photos with EXIF orientation `6` / 90° CW), `ImageConversionService` currently exhibits a double-rotation bug:
1. `destinationProperties` copies the source EXIF/TIFF metadata verbatim when `settings.preserveMetadata` is `true`.
2. The resize branch uses `CGImageSourceCreateThumbnailAtIndex` with `kCGImageSourceCreateThumbnailWithTransform: true`, which physically bakes the orientation transform into the decoded pixel buffer.
3. The destination encoder (`CGImageDestinationAddImage`) receives both physically rotated pixels AND the original `Orientation = 6` tag in `destinationProperties`.
4. Image viewers inspect the tag and apply a second 90° rotation, displaying the resized image upside down or incorrectly oriented.

Additionally, metadata preservation requires strict verification to ensure:
- When resized with transform, orientation tags are normalized to `1` (normal / top-left) across root and `{TIFF}` dictionaries.
- When `preserveMetadata` is `false`, sensitive and format metadata (EXIF, GPS, IPTC) are completely excluded.
- Stale embedded thumbnails from the original image are stripped so the thumbnail does not desync with resized pixels.

## Proposed Solution
1. **Metadata Sanitization Pipeline**: Separate metadata extraction and sanitization from the decode path.
2. **Orientation Normalization on Resized Images**: When resizing with `kCGImageSourceCreateThumbnailWithTransform: true`, normalize `kCGImagePropertyOrientation` and `{TIFF}.Orientation` to `1` in `destinationProperties`.
3. **Thumbnail Metadata Stripping**: Remove any legacy thumbnail references or embedded thumbnail dictionaries when scaling/resizing.
4. **Comprehensive Swift Testing Suite**: Add test fixtures with orientation tags (e.g., orientation 6, 8, 3) and unit tests verifying:
   - Resize with transform normalizes orientation to 1 in the resulting output.
   - Non-resized conversion preserves the original orientation tag and unrotated pixel buffer.
   - `preserveMetadata == false` strips EXIF / GPS metadata.

## Rollback Plan
If regressions occur during conversion encoding, revert changes in `ImageConversionService.swift` back to the standard pass-through metadata dictionary.
