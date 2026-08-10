# Conversion Domain Capability Spec

## Requirements

### Requirement: Image Format Enumeration

The Conversions domain MUST define `ImageFormat` as a raw-value-backed enumeration covering PNG, JPG, WebP, AVIF, SVG, TIF, HEIC, JPEG 2000, and JPEG XL. Construction from an unrecognized raw value MUST yield a well-defined, non-crashing result. WebP and JPEG XL MUST be import-only and MUST NOT be offered as conversion output (target) formats.

#### Scenario: Known format round-trip

- **GIVEN** each supported raw value (PNG, JPG, WebP, AVIF, SVG, TIF, HEIC, JP2, JXL)
- **WHEN** an `ImageFormat` is constructed from it
- **THEN** the resulting format's raw value equals the input

#### Scenario: Unknown raw value is safe

- **GIVEN** a raw value outside the supported set (e.g. "BMP")
- **WHEN** construction is attempted
- **THEN** the outcome is deterministic and does not crash

#### Scenario: Decode-only formats excluded from output

- **GIVEN** the set of eligible conversion target formats
- **WHEN** WebP or JPEG XL is checked against that set
- **THEN** neither appears in it

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

`BatchQueueItem` MUST carry typed fields (format, optional target format, numeric dimensions, original and target byte counts) and MUST NOT store selection state or a reduction value. `targetFormat` MUST be optional; an item with no chosen target MUST display a "no target yet" placeholder, with no target size or reduction shown.

#### Scenario: Selection lives in the scene

- **GIVEN** a batch queue item rendered in `ConvertScene`
- **WHEN** the user toggles its selection
- **THEN** scene-level selection state changes and the item's domain value is unchanged

#### Scenario: No target chosen yet

- **GIVEN** a newly imported `BatchQueueItem` with `targetFormat == nil`
- **WHEN** its row is rendered
- **THEN** it displays a "no target yet" placeholder, with no target size or reduction shown

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

### Requirement: Batch Item Status Enum

The system MUST define `BatchItemStatus` as an enum with cases `.queued`, `.converting`, `.done`, and `.failed`. `BatchQueueItem` MUST carry a `status` property defaulting to `.queued`.

#### Scenario: New item defaults to queued

- GIVEN a `BatchQueueItem` created without specifying a status
- WHEN the item is instantiated
- THEN `status` equals `.queued`

#### Scenario: Status transitions through all cases

- GIVEN a `BatchQueueItem` at any status
- WHEN `status` is reassigned to `.queued`, `.converting`, `.done`, or `.failed`
- THEN the value matches the assigned case

### Requirement: Status Progression in Batch Pipeline

`ConvertScene.processBatchConversion()` MUST set each item's status to `.converting` before conversion begins, and to `.done` on success or `.failed` on error.

#### Scenario: Converting then done

- GIVEN a batch item with `status` `.queued`
- WHEN conversion starts for that item
- THEN `status` equals `.converting`
- AND when conversion completes without error
- THEN `status` equals `.done`

#### Scenario: Converting then failed

- GIVEN a batch item with `status` `.queued`
- WHEN conversion fails for that item
- THEN `status` equals `.failed`

### Requirement: Visual Status Badges

`BatchQueueItemRow` MUST render distinct visual indicators for each status: a spinner for `.converting`, a green checkmark for `.done`, and a red cross for `.failed`.

#### Scenario: Converting shows progress spinner

- GIVEN a batch item with `status` `.converting`
- WHEN its row is rendered in `BatchQueueView`
- THEN the row displays a `ProgressView` spinner and the text "Converting..."

#### Scenario: Done shows green checkmark

- GIVEN a batch item with `status` `.done`
- WHEN its row is rendered
- THEN the row displays a green "✓ Done" badge

#### Scenario: Failed shows red cross

- GIVEN a batch item with `status` `.failed`
- WHEN its row is rendered
- THEN the row displays a red "✕ Failed" badge
