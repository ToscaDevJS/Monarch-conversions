# Proposal: Dynamic Dashboard Metrics

## Problem
In `MetricsHeaderView`, the 5 stats ("Images processed", "In queue (24h)", "Converted today", "Storage saved", "Active projects") are hardcoded static strings (`28,492`, `12`, `1,574`, `748 GB`, `174`). They do not reflect real data from SwiftData `@Query` records.

## Proposed Solution
1. **SwiftData Data-Driven Metrics**: Query `@Query private var records: [ConversionRecord]` in `MetricsHeaderView`.
2. **Dynamic Computation**:
   - `Images processed`: Total count of records in SwiftData (or combined count).
   - `In queue (24h)`: Count of records with status `.working` (or timestamp within last 24 hours).
   - `Converted today`: Count of records with status `.done` created today (`Calendar.current.isDateInToday(record.timestamp)`).
   - `Storage saved`: Aggregate output byte size or estimated saved storage.
   - `Active projects`: Unique count of project strings (`Set(records.map { $0.project }).count`).
3. **Unit Tests**: Create `MetricsHeaderViewTests.swift` validating stats calculation logic.

## Impact
Turns the Studio Dashboard into a live, reactive analytics header.
