# Delta for Fix Deployment Target, Enable Spanish Localization in Project & Add CI Scripts

## ADDED Requirements

### Requirement: macOS 14.0 Deployment Target

All Xcode project targets (app target, unit test target, UI test target) MUST specify `MACOSX_DEPLOYMENT_TARGET = 14.0;`.

#### Scenario: Deployment target matches macOS Sonoma baseline
- **GIVEN** `Monarch-conversions.xcodeproj`
- **WHEN** project settings are evaluated
- **THEN** no targets reference invalid version `26.5`
- **AND** all target configurations specify `14.0`

### Requirement: Spanish Locale Known Region Inclusion

`knownRegions` in `project.pbxproj` MUST include `es` alongside `en` and `Base` to ensure String Catalogs are properly bundled for Spanish language users.

#### Scenario: knownRegions includes Spanish
- **GIVEN** `Monarch-conversions.xcodeproj/project.pbxproj`
- **WHEN** `knownRegions` is inspected
- **THEN** `es` is listed in the array

### Requirement: Standard Distribution & Test Automation Scripts

The project repository MUST provide automated command-line scripts in `scripts/` for building (`scripts/build.sh`), testing (`scripts/test.sh`), and archiving (`scripts/archive.sh`).

#### Scenario: Test script executes test suite
- **GIVEN** `scripts/test.sh`
- **WHEN** executed
- **THEN** it runs `xcodebuild test` for scheme `Monarch-conversions` and returns the process exit code
