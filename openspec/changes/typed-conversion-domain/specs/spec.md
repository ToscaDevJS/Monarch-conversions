# Typed Conversion Domain — Spec Delta

Two NEW capabilities (`openspec/specs/` does not exist yet; both sections are complete new specs).

# Delta for conversion-domain

## ADDED Requirements

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

# Delta for conversion-formatting

## ADDED Requirements

### Requirement: Byte Size Formatting

A size formatter MUST render byte counts as integer KB with a " KB" suffix below the MB threshold, and as one-decimal MB with a " MB" suffix at or above it. Seeded/mock byte counts and the formatter MUST be mutually consistent so every size string visible today is reproduced exactly (e.g. "684 KB", "412 KB", "96 KB", "1.2 MB", "2.8 MB", "4.1 MB", "420 KB").

#### Scenario: KB rendering

- **GIVEN** the byte count seeded for the `hero-banner.png` output
- **WHEN** formatted
- **THEN** the result is exactly "684 KB"

#### Scenario: MB rendering

- **GIVEN** the byte count behind the mock original size of `hero-banner.png`
- **WHEN** formatted
- **THEN** the result is exactly "2.8 MB"

### Requirement: Dimensions Formatting

A dimensions formatter MUST render "{width} × {height}" using the multiplication sign (U+00D7) with a single space on each side.

#### Scenario: Dimensions string

- **GIVEN** width 4096 and height 2731
- **WHEN** formatted
- **THEN** the result is exactly "4096 × 2731"

### Requirement: Reduction Percentage Formatting

A reduction formatter MUST render the computed reduction as a signed integer percentage rounded to the nearest whole percent (e.g. "-85%"); a zero reduction renders "0%".

#### Scenario: Mock reduction parity

- **GIVEN** the byte counts behind the "2.8 MB" original and "420 KB" target mocks
- **WHEN** the computed reduction is formatted
- **THEN** the result is exactly "-85%"

#### Scenario: Rounding

- **GIVEN** original 1000 bytes and target 147 bytes
- **WHEN** the computed reduction is formatted
- **THEN** the result is exactly "-85%"

### Requirement: Format Display Names

`ImageFormat` presentation MUST reproduce today's visible names: PNG, JPG, WebP, AVIF, SVG, TIF (mixed case "WebP" preserved).

#### Scenario: WebP display name

- **GIVEN** the WebP format
- **WHEN** its display name is rendered
- **THEN** the result is exactly "WebP"

### Requirement: Presentation-Layer Formatting Only

Formatting helpers MUST live in the Conversions feature presentation layer and be consumed by feature views and scenes (App → Scenes → Features → Core preserved). Formatted strings MUST NOT be persisted or stored on domain models. Visible UI strings after the change MUST be identical to today's.

#### Scenario: UI string parity

- **GIVEN** the seeded records and mock batch items
- **WHEN** `ConversionsTableView` and `BatchQueueItemRow` render
- **THEN** visible size, dimension, and percentage strings equal today's exactly (e.g. "684 KB", "4096 × 2731", "420 KB (-85%)")
