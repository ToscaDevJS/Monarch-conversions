# Conversion Domain Capability Spec

## Requirements

### Requirement: Image Format Enumeration

The Conversions domain MUST define `ImageFormat` as a raw-value-backed enumeration covering every format present in seed and mock data: PNG, JPG, WebP, AVIF, SVG, TIF. Construction from an unrecognized raw value MUST yield a well-defined, non-crashing result (the mechanism is a design decision).

#### Scenario: Known format round-trip

- **GIVEN** each supported raw value (PNG, JPG, WebP, AVIF, SVG, TIF)
- **WHEN** an `ImageFormat` is constructed from it
- **THEN** the resulting format's raw value equals the input

#### Scenario: Unknown raw value is safe

- **GIVEN** a raw value outside the supported set (e.g. "BMP")
- **WHEN** construction is attempted
- **THEN** the outcome is deterministic and does not crash

### Requirement: Numeric Pixel Dimensions

Image dimensions MUST be represented as integer pixel width and height, never as a formatted string.

#### Scenario: Dimensions hold numeric components

- **GIVEN** width 4096 and height 2731
- **WHEN** a dimensions value is created
- **THEN** width reads 4096 and height reads 2731 as integers

### Requirement: Typed Conversion Record

`ConversionRecord` MUST persist input/output formats as `ImageFormat`, dimensions as numeric width/height, and output size as an integer byte count, keeping the existing status lifecycle (`working`, `done`). Domain models MUST NOT store presentation strings (no "KB", "MB", "×", or "%").

#### Scenario: Record stores typed values

- **GIVEN** a record for `hero-banner.png` (PNG → WebP, 4096 by 2731, output byte count)
- **WHEN** it is saved and fetched via SwiftData
- **THEN** formats are `ImageFormat` values, dimensions are integers, size is an integer byte count, status is `working`

### Requirement: Typed Batch Queue Item Without Selection State

`BatchQueueItem` MUST carry typed fields (format, target format, numeric dimensions, original and target byte counts) and MUST NOT store selection state or a reduction value.

#### Scenario: Selection lives in the scene

- **GIVEN** a batch queue item rendered in `ConvertScene`
- **WHEN** the user toggles its selection
- **THEN** scene-level selection state changes and the item's domain value is unchanged

### Requirement: Computed Reduction

Reduction MUST be computed from original and target byte counts as (target − original) / original, and MUST NOT be stored.

#### Scenario: Standard reduction

- **GIVEN** original 1000 bytes and target 150 bytes
- **WHEN** reduction is computed
- **THEN** the result is −85%

#### Scenario: Zero original size

- **GIVEN** original 0 bytes
- **WHEN** reduction is computed
- **THEN** the result is defined as zero (no division failure)

### Requirement: Typed Disposable Seed Data

The seed service MUST seed the same six conversion records with typed values, idempotently. The store is disposable seed data: on schema change it MAY be regenerated; versioned migration MUST NOT be required.

#### Scenario: Seeding an empty store

- **GIVEN** an empty store
- **WHEN** seeding runs twice
- **THEN** exactly six typed records exist

#### Scenario: Incompatible prior store

- **GIVEN** a store created with the old string schema
- **WHEN** the app initializes its model container
- **THEN** it recovers by regenerating typed seed data, without a versioned migration
