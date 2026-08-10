# Delta for Batch Queue Status

## ADDED Requirements

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
