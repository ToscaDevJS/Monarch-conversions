# Delta for Prevent Batch Duplicate Conversions

## ADDED Requirements

### Requirement: Idempotent Batch Queue Processing

Batch conversion execution MUST only select items whose status is `.queued`. Items already marked `.done` MUST be bypassed and MUST NOT be re-converted, overwritten, or re-inserted into the `ConversionRecord` history store.

#### Scenario: Partially completed batch converts only queued items
- **GIVEN** a queue containing 2 items with status `.done` and 1 item with status `.queued`
- **WHEN** batch conversion is initiated
- **THEN** only the 1 item with status `.queued` is converted
- **AND** the 2 `.done` items remain unmodified

#### Scenario: Fully completed batch performs no work and inserts no duplicate records
- **GIVEN** a queue where all items have status `.done`
- **WHEN** batch conversion is initiated
- **THEN** 0 conversions are executed
- **AND** 0 new `ConversionRecord` rows are inserted into the database

### Requirement: Queue Mutation Protection During Processing

Destructive operations such as clearing the entire queue (`clearQueue`) or deleting the selected item (`deleteSelectedItem`) MUST be ignored or disabled while a batch conversion is actively processing (`isProcessing == true`).

#### Scenario: Clear queue ignored while processing
- **GIVEN** a batch conversion currently in progress (`isProcessing == true`)
- **WHEN** clear queue action is triggered
- **THEN** the queue is preserved intact and no index-out-of-range crash occurs
