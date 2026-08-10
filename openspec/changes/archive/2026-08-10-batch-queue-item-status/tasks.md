# Tasks: Real-Time Batch Queue Item Status Indicators

## Unit 1: Status Field & Conversion Tracking
- [x] Add `BatchItemStatus` enum and `status` property to `BatchQueueItem.swift`.
- [x] Update `ConvertScene.swift` to mutate `items[index].status` during conversion iterations.

## Unit 2: UI Badges & Animations
- [x] Update `BatchQueueItemRow.swift` to render progress spinner for `.converting` and checkmark for `.done`.

## Unit 3: Verification & Unit Tests
- [x] Create `BatchQueueItemStatusTests.swift` testing status transitions.
- [x] Run `xcodebuild test` and produce `verify-report.md`.
