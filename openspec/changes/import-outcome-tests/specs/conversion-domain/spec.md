# Delta for ImportOutcome Unit Test Coverage

## ADDED Requirements

### Requirement: ImportOutcome Encapsulation & Case Discrimination

`ImportOutcome` MUST represent the result of importing an individual file into the conversion pipeline as an enum with two distinct cases:
1. `.accepted(BatchQueueItem)` representing successful validation and metadata extraction.
2. `.rejected(ImportRejection)` representing rejected files along with structured failure reasons.

#### Scenario: Accepted file produces accepted outcome
- **GIVEN** a valid `BatchQueueItem`
- **WHEN** wrapped in `ImportOutcome.accepted`
- **THEN** pattern matching on `.accepted(let item)` recovers the exact `BatchQueueItem`

#### Scenario: Rejected file produces rejected outcome
- **GIVEN** an `ImportRejection` with a specific reason
- **WHEN** wrapped in `ImportOutcome.rejected`
- **THEN** pattern matching on `.rejected(let rejection)` recovers the exact `ImportRejection` and failure reason

### Requirement: Value Equality (Equatable)

`ImportOutcome` MUST conform to `Equatable`. Two `ImportOutcome` instances with equivalent payloads MUST compare equal (`==`). Two instances with different payloads or different enum cases MUST NOT compare equal (`!=`).

#### Scenario: Same case and identical payload compare equal
- **GIVEN** two `.accepted` outcomes wrapping identical `BatchQueueItem`s (or two `.rejected` outcomes wrapping identical `ImportRejection`s)
- **WHEN** evaluated for equality
- **THEN** `#expect(a == b)` evaluates to true

#### Scenario: Differing cases or payloads compare unequal
- **GIVEN** an `.accepted` outcome and a `.rejected` outcome (or two outcomes with distinct payload values)
- **WHEN** evaluated for equality
- **THEN** `#expect(a != b)` evaluates to true

### Requirement: Concurrency Safety (Sendable)

`ImportOutcome` MUST conform to `Sendable` and be `nonisolated`, allowing instances to safely cross Swift Concurrency actor and task boundaries without data isolation warnings.

#### Scenario: Passing outcomes across asynchronous tasks
- **GIVEN** an `ImportOutcome` value
- **WHEN** transferred across an asynchronous `Task` boundary
- **THEN** the value is preserved without concurrency warnings or data races
