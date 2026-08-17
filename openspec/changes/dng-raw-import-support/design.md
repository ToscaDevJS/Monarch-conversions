# Design: DNG RAW Image Pipeline Architecture

## Architecture Overview
The DNG import and conversion pipeline follows the standard Core Graphics and ImageIO pipeline:
`DropZone / Picker` -> `ImageImportService` -> `ImageFormat` -> `ImageConversionService` (ImageIO) -> Output format.

## Architecture Decisions

### 1. Treat DNG as Decode-Only / Import-Only
- **Decision**: Mark `.dng` as an input format only. Exclude `.dng` from `ImageFormat.outputEligibleCases`.
- **Rationale**: DNG / RAW is a camera sensor capture format and archival container. Generating synthetic RAW DNG files from lossy/raster inputs is outside Monarch's scope, whereas decoding RAW camera files into modern web formats (JPG, PNG, WebP, AVIF, HEIC) is the primary user requirement.

### 2. Native ImageIO RAW Decoding
- **Decision**: Utilize Apple's native Core Graphics / ImageIO RAW engine via `CGImageSourceCreateWithURL` and `CGImageSourceCreateImageAtIndex`.
- **Rationale**: macOS provides hardware-accelerated RAW decoding (including Apple ProRAW and Adobe DNG standard) out of the box with zero third-party C library overhead.

## Data Flow Diagram

```
[ .DNG File Drag/Pick ]
          │
          ▼
[ ImageImportService ]
   ├─ Check format: ImageFormat(fileExtension: "dng") == .dng
   ├─ Check size <= 100MB
   └─ CGImageSourceCreateWithURL ──> Read pixel dimensions (width × height)
          │
          ▼
[ BatchQueueItem (.dng) ]
          │
          ▼
[ ImageConversionService.convert() ]
   ├─ CGImageSourceCreateWithURL
   ├─ CGImageSourceCreateImageAtIndex(source, 0, nil) ──> Decode RAW to CGImage
   └─ CGImageDestinationCreateWithURL ──> Encode to Target (JPG, PNG, WebP, AVIF, HEIC)
```
