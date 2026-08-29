# Design: Dashboard History Preservation & Shared Scheme

## Architecture Changes

### 1. Dashboard Cleanup Removal
In `Scenes/Dashboard/DashboardScene.swift`:
- Remove private method `cleanLegacySeedsIfNeeded()`.
- Remove `.onAppear { cleanLegacySeedsIfNeeded() }` from the view body.
- The `DashboardScene` now behaves strictly as a presentational consumer and query surface over the `@Query var records: [ConversionRecord]` SwiftData collection.

### 2. Shared Scheme Definition
The shared scheme `Monarch-conversions.xcscheme` is placed in `Monarch-conversions.xcodeproj/xcshareddata/xcschemes/`. It defines buildables and testables for:
- `Monarch-conversions` (Application)
- `Monarch-conversionsTests` (Unit Tests)
- `Monarch-conversionsUITests` (UI Tests)

## Test Strategy (`DashboardHistoryPreservationTests.swift`)

Using Swift Testing and an in-memory `ModelContainer(for: ConversionRecord.self)`:
- Insert records with legacy filenames (`"team-photo.png"`, `"hero-banner.png"`, `"product-shot.jpg"`) and project categories (`"Marketing"`, `"Brand"`, `"Storefront"`).
- Verify that standard queries retrieve all records and that no automated deletion routine alters the record count.
