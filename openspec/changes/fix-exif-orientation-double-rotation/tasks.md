# Tasks: Fix EXIF Orientation Double Rotation & Metadata Synchronization

## Phase 1: Test Suite & Fixture Preparation (TDD)
- [x] 1.1 Create fixture images with EXIF orientation (e.g. Orientation = 6 / 90° CW) in `Monarch-conversionsTests/Fixtures`.
- [x] 1.2 Write unit test `test_resizeWithExifOrientation_normalizesOrientationTagToOne` in `ImageConversionServiceTests.swift`.
- [x] 1.3 Write unit test `test_convertWithoutResize_preservesOriginalOrientationTag` in `ImageConversionServiceTests.swift`.
- [x] 1.4 Write unit test `test_convertWithPreserveMetadataFalse_stripsExifAndGpsMetadata` in `ImageConversionServiceTests.swift`.

## Phase 2: Implementation in ImageConversionService
- [x] 2.1 Update metadata extraction logic in `ImageConversionService.swift` to support clean mutation of orientation properties.
- [x] 2.2 In the resize branch (`CGImageSourceCreateThumbnailAtIndex` with transform), set root `kCGImagePropertyOrientation` and TIFF `kCGImagePropertyTIFFOrientation` to 1.
- [x] 2.3 Strip embedded thumbnail metadata dictionary keys to prevent miniature desync.

## Phase 3: Verification & SDD Closeout
- [x] 3.1 Run `xcodebuild test` to verify all new and existing test suites pass.
- [x] 3.2 Generate verification report `verify-report.md`.
