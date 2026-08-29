# Delta for Resilient ModelContainer Initialization & Store Preservation

## ADDED Requirements

### Requirement: Non-Destructive Database Failure Recovery

When `ModelContainer` initialization fails due to schema mismatch or store file corruption:
1. The system MUST NOT delete existing `.store`, `.store-shm`, or `.store-wal` files.
2. The system MUST rename or move the existing store files aside to a backup location (`.bak` or timestamped backup) before initializing a fresh store.

#### Scenario: Corrupted store file is backed up
- **GIVEN** an unreadable or corrupt SQLite store file at the target URL
- **WHEN** `ModelContainerFactory.createContainer` is called
- **THEN** a backup file matching `*.bak` exists containing the original bytes
- **AND** the returned `ModelContainer` is initialized and functional

### Requirement: Graceful Degradation Without Fatal Crash

If persistent disk storage cannot be initialized even after moving the store aside (e.g. read-only volume, disk permission restriction), the factory MUST return an in-memory `ModelContainer` instead of crashing with `fatalError`.

#### Scenario: Unwritable disk degrades to in-memory container
- **GIVEN** an unwritable or inaccessible storage directory
- **WHEN** `ModelContainerFactory.createContainer` is called
- **THEN** a valid in-memory `ModelContainer` is returned
- **AND** no `fatalError` or application crash occurs
