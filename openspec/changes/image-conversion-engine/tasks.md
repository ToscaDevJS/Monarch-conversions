# Tasks: Core Image Conversion Engine

## Unit 1: Core Engine Services
- [x] Create `ConversionSettings` struct representing format, quality, max dimensions, and metadata preferences.
- [x] Create `ImageConversionService` implementing `CGImageSource` and `CGImageDestination` conversion pipelines.
- [x] Support format UTIs for JPEG, PNG, WebP, AVIF, and HEIC.
- [x] Implement image resizing and quality compression parameter passing.

## Unit 2: Queue Pipeline & SwiftData Integration
- [x] Connect `ImageConversionService` to update `BatchQueueItem` status (`processing`, `completed`, `failed`) and `progress` (0.0 to 1.0).
- [x] Instantiate and persist `ConversionRecord` upon successful conversion in SwiftData `ModelContext`.
- [x] Connect conversion queue triggers in `ConvertScene` and output controls.

## Unit 3: Verification & Unit Tests
- [x] Create `ImageConversionServiceTests` to test end-to-end conversion of sample image files.
- [x] Verify `ConversionRecord` persistence and item progress updates.
- [x] Run `xcodebuild test` and produce `verify-report.md`.
