# Conversion Formatting Capability Spec

## Requirements

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
