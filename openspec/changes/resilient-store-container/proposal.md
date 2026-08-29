# Proposal: Resilient ModelContainer Initialization & Store Preservation

## Intent

As identified in `LAUNCH-TRIAGE.md` (Defect 03), `Monarch_conversionsApp.swift` destroys the user's database (`default.store`, `-shm`, `-wal`) via `removeDefaultStoreFiles()` when `ModelContainer` initialization fails (which occurs during unmigrated schema changes or corrupted SQLite files). Furthermore, if persistent retry fails, line 25 calls `fatalError`, causing an unrecoverable launch crash.

## Scope

### In Scope
- Create `ModelContainerFactory` responsible for initializing SwiftData `ModelContainer` instances safely.
- Never delete failed store files: relocate incompatible/corrupted database files to timestamped backup files (`default.store.corrupt-{timestamp}.bak`).
- Degrade gracefully to an in-memory `ModelContainer` if persistent disk creation cannot succeed, eliminating `fatalError` launch crashes.
- Strict TDD: Author tests in `Monarch-conversionsTests/ModelContainerFactoryTests.swift` verifying backup creation and graceful in-memory degradation.

### Out of Scope
- Complex multi-version SwiftData schema migration pipelines (data models are currently stable; this provides the safety net).

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added requirements for resilient store recovery, backup on schema mismatch, and zero fatal crashes during container startup.

## Approach

1. **RED Phase**: Write unit tests in `Monarch-conversionsTests/ModelContainerFactoryTests.swift` testing that opening a corrupt/invalid store backs up the file rather than deleting it and returns a valid functional container without crashing. Run `xcodebuild test` to observe failure.
2. **GREEN Phase**: Implement `ModelContainerFactory.swift` and integrate into `Monarch_conversionsApp.swift`.
3. **REFACTOR Phase**: Verify all tests pass, run full test suite with 0 regressions, and validate SDD compliance.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions/Core/Storage/ModelContainerFactory.swift` | New | Resilient container creation and backup logic |
| `Monarch-conversions/App/Monarch_conversionsApp.swift` | Modified | Use `ModelContainerFactory` and remove destructive `removeDefaultStoreFiles()` |
| `Monarch-conversionsTests/ModelContainerFactoryTests.swift` | New | Unit tests for backup creation and in-memory degradation |
| `openspec/changes/resilient-store-container/` | New | SDD specifications and verification report |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Disk full preventing backup copy | Low | Attempt rename/move (`FileManager.moveItem`), fallback to in-memory container |

## Success Criteria

- [ ] Corrupt/incompatible store files are preserved as backups and never destroyed.
- [ ] Container initialization never terminates via `fatalError`.
- [ ] 100% tests pass in `xcodebuild test`.
