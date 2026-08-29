# Delta for Dashboard History Preservation & Shared Scheme

## ADDED Requirements

### Requirement: Durable Conversion Record Persistence

The Dashboard scene and Conversions domain MUST NOT delete or filter out persisted `ConversionRecord` instances based on hardcoded demo filenames (e.g. `team-photo.png`, `hero-banner.png`, `product-shot.jpg`, etc.) or project categories (e.g. `Marketing`, `Storefront`, `Brand`, `Events`). All records inserted by the user or import pipeline MUST remain in the model store until explicitly deleted by the user.

#### Scenario: User records with demo names are preserved
- **GIVEN** a SwiftData model context containing records with filenames `team-photo.png`, `hero-banner.png`, or `launch-grid.jpg`
- **WHEN** the records are queried or loaded in the Dashboard
- **THEN** all records remain intact in the database and are not deleted

#### Scenario: User records with standard marketing projects are preserved
- **GIVEN** a SwiftData model context containing records assigned to project `Marketing`, `Storefront`, `Brand`, or `Events`
- **WHEN** the records are queried or loaded in the Dashboard
- **THEN** all records remain intact in the database and are not deleted

### Requirement: Shared Xcode Scheme Configuration

The Xcode project MUST contain a committed shared scheme `Monarch-conversions.xcscheme` in `Monarch-conversions.xcodeproj/xcshareddata/xcschemes/` configured to build, run, test, profile, and archive the main application and its test suites on any machine or CI environment.

#### Scenario: Listing project schemes from clean clone
- **GIVEN** a freshly cloned checkout without user-specific `xcuserdata`
- **WHEN** running `xcodebuild -list -project Monarch-conversions.xcodeproj`
- **THEN** the `Monarch-conversions` scheme is recognized and listed under Schemes
