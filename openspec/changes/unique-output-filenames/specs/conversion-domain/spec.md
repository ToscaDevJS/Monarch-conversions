# Delta for Unique Output Filenames on Collision

## ADDED Requirements

### Requirement: Collision-Free Unique Output Filename Resolution

`ImageConversionService` MUST verify whether a candidate output file path already exists on disk before initializing image destination writing. If `{fileBaseName}_converted.{ext}` already exists, the service MUST generate an incrementally suffixed filename (e.g. `{fileBaseName}_converted-1.{ext}`, `{fileBaseName}_converted-2.{ext}`, etc.) so that existing files are never overwritten.

#### Scenario: No existing file uses standard output name
- **GIVEN** an output directory where `photo_converted.webp` does not exist
- **WHEN** converting `photo.png` to `.webp`
- **THEN** the produced output file is named `photo_converted.webp`

#### Scenario: Existing file triggers numeric suffix -1
- **GIVEN** an output directory where `photo_converted.webp` already exists
- **WHEN** converting `photo.png` to `.webp`
- **THEN** the produced output file is named `photo_converted-1.webp`
- **AND** the original `photo_converted.webp` file content is preserved intact

#### Scenario: Multiple existing files trigger sequential suffix increment
- **GIVEN** an output directory where `photo_converted.webp` and `photo_converted-1.webp` both exist
- **WHEN** converting `photo.png` to `.webp`
- **THEN** the produced output file is named `photo_converted-2.webp`
