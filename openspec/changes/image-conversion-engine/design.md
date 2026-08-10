# Design: Core Image Conversion Engine

## Architecture & Data Flow

```
[User Action: Add batch to queue / Convert]
       │
       ▼
[ConvertScene / OutputSettings]
       │
       ▼
[ImageConversionService (Actor / MainActor)]
       │
       ├────► Load CGImageSource from input URL
       ├────► Apply options (scale, compression quality, metadata)
       ├────► CGImageDestinationCreateWithURL(targetURL, formatUTI, 1, nil)
       ├────► Write CGImageDestination & finalize
       │
       ▼
[Update BatchQueueItem progress & status]
       │
       ▼
[Persist ConversionRecord in SwiftData ModelContext]
```

## Component Architecture

1. **`ImageConversionService`**:
   - `func convert(item: BatchQueueItem, settings: ConversionSettings, context: ModelContext) async throws -> ConversionRecord`
   - Handles asynchronous thread-safe processing.
   - Calculates output byte sizes, elapsed times, and compression ratios.

2. **`ConversionSettings`**:
   - Value object encapsulating target UTI (e.g. `public.webp`, `public.png`, `public.jpeg`, `public.avif`), compression quality (0.0 - 1.0), max width/height scaling, and metadata stripping options.

3. **Format Support**:
   - Native macOS ImageIO via `CGImageSource` and `CGImageDestination`.

## Verification Plan
1. Unit tests in `ImageConversionServiceTests` verifying successful conversion of test images (JPEG/PNG -> WebP/JPEG/PNG).
2. SwiftData model context insertion test verifying `ConversionRecord` creation.
3. Pass `xcodebuild test` suite.
