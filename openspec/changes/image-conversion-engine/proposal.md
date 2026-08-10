# Proposal: Core Image Conversion Engine

## Problem
Monarch Conversions manages `BatchQueueItem` entries, inspects metadata, and renders UI components, but has no actual image processing engine. There is no `ImageConversionService` to convert input images to output formats (WebP, AVIF, JPEG, PNG, HEIC, etc.), report real-time conversion progress, or persist completed `ConversionRecord` items in SwiftData.

## Proposed Solution
1. **`ImageConversionService` Core**: Implement an asynchronous, concurrency-safe image conversion service that takes `BatchQueueItem` inputs, processes image pixels via ImageIO / `CGImageDestination`, and outputs converted files to the target destination path.
2. **Format Encoding & Options**: Support quality, resolution scaling, format transformation (JPEG, PNG, HEIC, WebP, AVIF), and metadata preservation options based on user output settings.
3. **Queue & Status Pipeline**: Connect `BatchQueueItem` state transitions (`pending` -> `processing` -> `completed` / `failed`) with atomic progress updates (`0.0` to `1.0`).
4. **Data Persistence**: Automatically generate and persist `ConversionRecord` entities in SwiftData upon successful conversion.
5. **UI Integration**: Wire the conversion queue action in `ConvertScene` to kick off conversion jobs in `ImageConversionService`.

## Impact
Turns Monarch Conversions into a fully functional batch image converter.
