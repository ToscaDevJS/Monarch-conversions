# Proposal: DNG (Digital Negative / RAW) Image Import & Conversion Support

## Problem
When users drag and drop `.dng` raw image files into Monarch's dropzone, the application rejects them with an unsupported format error (`Unsupported format (.dng)`).

Although macOS natively supports decoding DNG containers via ImageIO (`CGImageSource` and `com.adobe.raw-image`), `ImageFormat.swift` and `ImageImportService.swift` lacked the `.dng` format case and extension mapping, blocking import and conversion to web formats.

## Proposed Solution
1. **Extend `ImageFormat` Enum**: Add `case dng = "DNG"` to `ImageFormat` with mapping for `fileExtension: "dng"`.
2. **Decode-Only Classification**: Ensure `dng` is treated as a decode-only / input-only format (like `webp` and `jpegXL`), excluding it from `outputEligibleCases` so users cannot select DNG as an export format, but can convert DNG to JPG, PNG, WebP, AVIF, HEIC, or TIFF.
3. **Update `ImageImportService`**: Add `dng` to `allowedContentTypes` and file picker filters.
4. **Update `ImageConversionService`**: Ensure `ImageConversionService.uti(for:)` correctly classifies DNG and decodes raw image buffers via `CGImageSourceCreateImageAtIndex`.
5. **Strict TDD Verification**: Red-Green-Refactor test cycle with unit tests in `ImageFormatTests`, `ImageImportServiceTests`, and `ImageConversionServiceTests`.

## Rollback Plan
Reverting the additions to `ImageFormat.swift`, `ImageImportService.swift`, and `ImageConversionService.swift` restores previous format constraints without database schema changes or data corruption.

## Impact
Enables photographers and mobile creators to batch convert Apple ProRAW / Adobe DNG images directly to optimized web and distribution formats.
