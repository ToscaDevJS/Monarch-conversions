# Delta for Reveal Converted File in Finder

## ADDED Requirements

### Requirement: Batch Item Output File URL Storage

`BatchQueueItem` MUST carry an optional `outputFileURL: URL?` property defaulting to `nil`. When an image conversion succeeds, `ConvertScene.processBatchConversion()` MUST store the result's `outputURL` into the updated item.

#### Scenario: Item instantiated without output URL
- **GIVEN** a newly created `BatchQueueItem`
- **WHEN** no `outputFileURL` is passed
- **THEN** `outputFileURL` equals `nil`

#### Scenario: Output URL stored upon conversion completion
- **GIVEN** a batch item with status `.converting`
- **WHEN** conversion succeeds with an output URL
- **THEN** the updated batch item stores the exact output URL and status `.done`

### Requirement: Reveal in Finder Action

`BatchQueueItemRow` MUST provide a "Reveal in Finder" button and context menu item when `status == .done` and `outputFileURL` is non-nil. Triggering this action MUST invoke `NSWorkspace.shared.activateFileViewerSelecting([outputURL])`.

#### Scenario: Done item displays reveal button
- **GIVEN** an item with `status == .done` and a valid `outputFileURL`
- **WHEN** its row is rendered in `BatchQueueView`
- **THEN** an action button with accessibility identifier `"reveal-in-finder-button"` is displayed

#### Scenario: Non-done item omits reveal button
- **GIVEN** an item with status `.queued`, `.converting`, or `.failed`
- **WHEN** its row is rendered
- **THEN** the `"reveal-in-finder-button"` is not displayed

### Requirement: Unit and UI Test Verification

The output URL property, pipeline assignment, and UI presence of the reveal button MUST be validated with tests.

#### Scenario: Model equality and properties test
- **GIVEN** batch queue items with differing `outputFileURL`
- **WHEN** evaluated for equality and properties
- **THEN** `outputFileURL` is correctly tracked and compared
