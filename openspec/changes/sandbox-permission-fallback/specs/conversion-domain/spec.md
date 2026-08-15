# Delta for Sandbox Permission Fallback & Bookmark Management

## ADDED Requirements

### Requirement: Pre-flight Writable Directory Check & Fallback Destination Resolution

`ImageConversionService` MUST verify that the intended output directory is writable before attempting image destination creation. If the directory is not writable (e.g. parent directory of an imported file under App Sandbox restrictions), the service MUST fallback to the user's `Downloads` directory (`~/Downloads`).

#### Scenario: Writable custom directory is preserved
- **GIVEN** a custom output directory that is writable
- **WHEN** resolving destination URL for a conversion
- **THEN** the returned output directory is the custom directory

#### Scenario: Non-writable directory falls back to Downloads
- **GIVEN** an output destination directory where write permission is not granted
- **WHEN** resolving destination URL for a conversion
- **THEN** the returned output directory is `~/Downloads` (or system fallback directory)
- **AND** the resulting `ImageConversionResult` indicates fallback occurred

### Requirement: Security-Scoped Bookmark Support

`ImageConversionService` MUST resolve and bracket custom output URLs with `startAccessingSecurityScopedResource()` and `stopAccessingSecurityScopedResource()` during file writes.

#### Scenario: Security-scoped access bracketing
- **GIVEN** a security-scoped output directory URL
- **WHEN** image destination writing is initiated
- **THEN** security-scoped access is started before file creation
- **AND** security-scoped access is stopped via defer block upon completion or failure

### Requirement: UI Fallback Indication

`BatchQueueItemRow` and conversion outcomes MUST indicate to the user when a converted file was saved to the fallback `Downloads` folder rather than the original folder.

#### Scenario: Fallback badge display
- **GIVEN** an item whose conversion completed via sandbox fallback to Downloads
- **WHEN** its row is rendered in the batch queue or conversion details
- **THEN** an informative indicator ("Saved to Downloads") is presented

### Requirement: Unit and Integration Test Coverage

The sandbox fallback logic MUST be fully covered by unit tests verifying writable path determination, fallback path redirection, and destination creation.

#### Scenario: Writable vs non-writable path test
- **GIVEN** test source files and simulated non-writable directories
- **WHEN** `convert()` executes
- **THEN** the conversion succeeds without throwing `destinationCreationFailed`
- **AND** the output file exists in the fallback directory
