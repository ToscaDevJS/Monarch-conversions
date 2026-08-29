# Design: ImportOutcome Unit Test Coverage

## Component & Model Architecture

`ImportOutcome` is a lightweight discriminated union enum in the domain model layer (`Features/Conversions/Models/`):

```swift
public nonisolated enum ImportOutcome: Equatable, Sendable {
    case accepted(BatchQueueItem)
    case rejected(ImportRejection)
}
```

It is produced by `ImageImportService.importFiles(at:existingCount:)` and consumed by `ConvertScene` to populate the batch queue or display rejection banners.

## Test Suite Design (`ImportOutcomeTests.swift`)

Using Swift Testing framework (`import Testing`), the suite will be organized as follows:

```
ImportOutcomeTests (@Suite)
├── acceptedOutcomeHoldsBatchQueueItem (@Test)
│   └── Validates creation, case match, and payload extraction
├── rejectedOutcomeHoldsImportRejection (@Test)
│   └── Validates creation with all rejection reasons (.unsupportedType, .fileTooLarge, .batchLimitExceeded, .unreadable)
├── equatableConformanceForAcceptedOutcomes (@Test)
│   └── Validates == for identical BatchQueueItem and != for differing items
├── equatableConformanceForRejectedOutcomes (@Test)
│   └── Validates == for identical ImportRejection and != for differing rejections
├── inequalityBetweenDifferentCases (@Test)
│   └── Validates .accepted(item) != .rejected(rejection)
└── sendableAcrossConcurrencyBoundaries (@Test)
    └── Validates async transfer across Task { } boundaries
```

## Verification Strategy

- Run unit tests via `xcodebuild test -project Monarch-conversions.xcodeproj -scheme Monarch-conversions -destination "platform=macOS"`.
- Verify that CodeGraph recognizes the new test coverage.
