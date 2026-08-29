# Delta for Background Batch Conversion, Cancellation Handle & Error Diagnostics

## ADDED Requirements

### Requirement: Non-Blocking Background Batch Execution

Image decoding, transformation, and encoding MUST execute in background threads off `@MainActor` to prevent blocking the UI rendering loop.

#### Scenario: Heavy conversion offloads from MainActor
- **GIVEN** a batch conversion of image files
- **WHEN** batch processing begins
- **THEN** image conversion runs in a detached user-initiated background context
- **AND** UI state mutations and SwiftData `ModelContext` operations are synchronized on `@MainActor`

### Requirement: Cooperative Task Cancellation

The batch conversion processing pipeline MUST support immediate cooperative cancellation via `Task.cancel()`.

#### Scenario: Batch conversion cancelled mid-flight
- **GIVEN** an in-flight batch conversion with multiple remaining queued items
- **WHEN** cancellation is requested
- **THEN** current task loop terminates immediately
- **AND** remaining queued items are not converted
- **AND** `isProcessing` returns to `false`

### Requirement: Diagnostic Error Persistence on Failed Items

When an individual file conversion fails, the reason for the failure MUST be captured and stored in `BatchQueueItem.errorMessage`.

#### Scenario: Failed item captures error diagnostic
- **GIVEN** an unreadable or corrupt file in the conversion queue
- **WHEN** conversion fails
- **THEN** `item.status` is set to `.failed`
- **AND** `item.errorMessage` is populated with the localized failure description
