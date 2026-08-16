# Tasks: Reveal Converted File in Finder

## Unit 1: Domain Model & Pipeline Output URL Wiring
- [x] Add `outputFileURL: URL?` property to `BatchQueueItem.swift`.
- [x] Update `ConvertScene.swift` to pass `result.outputURL` to `updatedItem.outputFileURL` upon successful conversion.

## Unit 2: UI Reveal Action & Context Menu
- [x] Update `BatchQueueItemRow.swift` to add a "Reveal in Finder" button when `item.status == .done` and `outputFileURL != nil`.
- [x] Add context menu item on `BatchQueueItemRow` to reveal file in Finder.

## Unit 3: Verification & Tests
- [x] Update `BatchQueueItemTests.swift` to validate `outputFileURL` property handling.
- [x] Run test suite (`xcodebuild test`) and produce `verify-report.md`.
