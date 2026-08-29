# Proposal: ImportOutcome Unit Test Coverage

## Intent

CodeGraph index inspection revealed that `ImportOutcome` (`Features/Conversions/Models/ImportOutcome.swift:3`) has zero covering unit tests. Under the project's Strict TDD policy and hexagonal architecture discipline, domain models representing pipeline outcomes must have explicit test coverage verifying value semantics, pattern matching, equality, and concurrency safety.

## Scope

### In Scope
- Formalize specification for `ImportOutcome` value semantics under the `conversion-domain` capability.
- Unit test suite (`Monarch-conversionsTests/ImportOutcomeTests.swift`) utilizing Swift Testing (`@Suite`, `@Test`, `#expect`).
- Verification of enum cases (`.accepted`, `.rejected`), wrapped payloads (`BatchQueueItem`, `ImportRejection`), Equatable comparison, and Sendable conformance across task boundaries.
- OpenSpec artifact lifecycle: proposal, spec, design, tasks, and verify report.

### Out of Scope
- Modifying `ImportOutcome.swift` or `ImageImportService.swift` logic (they are already correctly structured).
- UI changes or presentation-layer modifications.

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added explicit requirements for `ImportOutcome` variant encapsulation and value equality.

## Approach

1. Document the change proposal, design, spec, and tasks in `openspec/changes/import-outcome-tests/`.
2. Follow Strict TDD: author comprehensive unit tests covering all cases, payloads, equality semantics, and Sendable properties in `Monarch-conversionsTests/ImportOutcomeTests.swift`.
3. Run the complete test suite with `xcodebuild test`.
4. Produce the verification report (`verify-report.md`) confirming 100% test pass rate and zero regressions.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions/Features/Conversions/Models/ImportOutcome.swift` | Target | Existing domain model under test |
| `Monarch-conversionsTests/ImportOutcomeTests.swift` | New | Comprehensive Swift Testing suite for `ImportOutcome` |
| `openspec/changes/import-outcome-tests/` | New | Complete SDD artifacts (proposal, design, spec, tasks, verify report) |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Xcode build target missing new test file | Low | Target uses `PBXFileSystemSynchronizedRootGroup` which automatically includes files in `Monarch-conversionsTests/` |
| Concurrency warnings under Swift 6 | Low | `ImportOutcome`, `BatchQueueItem`, and `ImportRejection` all explicitly conform to `Sendable` |

## Success Criteria

- [ ] `ImportOutcome` has dedicated test coverage in `Monarch-conversionsTests/ImportOutcomeTests.swift`.
- [ ] All tests pass cleanly via `xcodebuild test`.
- [ ] SDD cycle is complete with all required OpenSpec artifacts validated.
