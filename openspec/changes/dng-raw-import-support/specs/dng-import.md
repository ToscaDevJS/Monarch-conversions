# Specification: DNG RAW Image Import & Conversion

## Requirement
The application MUST accept `.dng` (Digital Negative / RAW) files for import, display accurate dimensions and metadata in the batch queue, and convert them to any supported target format (JPG, PNG, WebP, AVIF, HEIC, TIFF).

## Functional Requirements

### 1. Format Recognition & Mapping
- `ImageFormat(fileExtension: "dng")` and `ImageFormat(fileExtension: "DNG")` MUST return `.dng`.
- `ImageFormat.dng.rawValue` MUST equal `"DNG"`.
- `ImageFormat.outputEligibleCases` MUST NOT contain `.dng` (DNG is decode-only).

#### Scenario: Parse DNG extension
- **Given** a file path with extension `.dng` or `.DNG`
- **When** `ImageFormat(fileExtension:)` is evaluated
- **Then** it MUST resolve to `ImageFormat.dng`.

### 2. Import & Validation
- `ImageImportService.allowedContentTypes` MUST include the UTType for `.dng` (`com.adobe.raw-image` / `dng`).
- Dragging or picking a `.dng` file under 100 MB MUST be accepted into the batch queue with valid `PixelDimensions`.

#### Scenario: Import valid DNG image
- **Given** a valid `.dng` image file
- **When** the file is imported via `ImageImportService.importFiles(at:existingCount:)`
- **Then** the outcome MUST be `.accepted` with correct pixel dimensions and byte size.

### 3. Image Conversion
- Converting a `.dng` file to an output-eligible target format (such as JPG, PNG, WebP, AVIF) MUST produce a valid output file at the destination directory.

#### Scenario: Convert DNG to PNG/JPG
- **Given** an accepted `.dng` batch queue item
- **When** conversion is triggered with target format JPG or PNG
- **Then** `ImageConversionService` MUST decode the RAW buffer and write the destination file successfully.
