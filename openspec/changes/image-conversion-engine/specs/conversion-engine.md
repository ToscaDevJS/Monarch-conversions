# Conversion Engine Specification

## Requirement
The application must provide a thread-safe, asynchronous image conversion service capable of reading supported source images and writing converted images to disk based on user parameters.

## Functional Specs
1. **Input Sources**: `URL` pointing to local image files (JPEG, PNG, WebP, AVIF, TIFF, HEIC).
2. **Output Target**: User-selected directory or original parent directory.
3. **Format Options**:
   - `public.jpeg` (.jpg)
   - `public.png` (.png)
   - `public.heic` (.heic)
   - `org.webmproject.webp` / `public.webp` (.webp)
   - `public.avif` (.avif)
4. **Quality & Scale**:
   - Compression quality scalar [0.0 - 1.0].
   - Max width and max height bounding box maintain-aspect-ratio scaling.
5. **Persistence**:
   - Save a `ConversionRecord` entity containing `originalSize`, `convertedSize`, `savedBytes`, `duration`, `status`, and `outputPath` into SwiftData.
