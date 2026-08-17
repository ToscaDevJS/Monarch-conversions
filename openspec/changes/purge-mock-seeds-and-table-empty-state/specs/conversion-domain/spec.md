# Delta for Purge Mock Seeds & Table Empty State

## ADDED Requirements

### Requirement: Authentic Metric & History Representation

The application database and dashboard MUST only persist and display real user-triggered image conversions. Pre-seeded or dummy records MUST NOT be injected upon launch.

#### Scenario: First app launch
- **GIVEN** a new or existing user installation
- **WHEN** the application opens `DashboardScene`
- **THEN** no mock conversion records are injected and SwiftData reflects 0 initial records

#### Scenario: Real conversion recording
- **GIVEN** a user converts batch items in `ConvertScene`
- **WHEN** conversion succeeds
- **THEN** `ConversionRecord` is inserted into `ModelContext` with genuine dimensions, formats, and file size

### Requirement: Table Empty State

`ConversionsTableView` MUST display a structured empty state view when the dataset contains 0 records or when search/filtering yields no results.

#### Scenario: Empty history state
- **GIVEN** 0 conversion records in SwiftData
- **WHEN** `ConversionsTableView` renders
- **THEN** it displays `TableEmptyStateView` with a call to action navigating to `AppTab.convert`

#### Scenario: No filter matches state
- **GIVEN** conversion records exist but search query or filter matches none
- **WHEN** `ConversionsTableView` renders
- **THEN** it displays a filtered empty state with a "Reset Filters" action
