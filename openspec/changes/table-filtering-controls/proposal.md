# Proposal: Interactive Table Filtering & Reset Controls

## Problem
In `ConversionsTableView`, the header contains 4 dropdown controls (`Status`, `Input`, `Output`, `Project`) and a `Reset` button, but they are currently non-functional UI placeholders. Users cannot filter conversion records by status (Working/Done), input format, output format, or project, nor can they reset filters to show all records.

## Proposed Solution
1. **Interactive Filter Dropdowns**: Convert the static `FilterDropdown` views into interactive SwiftUI `Menu` controls bound to active filter states (`selectedStatus`, `selectedInputFormat`, `selectedOutputFormat`, `selectedProject`).
2. **Dynamic Query & Filtering**: Dynamically compute unique project values from records and filter the displayed `ConversionRecord` list in memory or via predicate matching based on active selection.
3. **Reset Control**: Connect the `Reset` button to clear all selected filters back to `.all` / `nil`.
4. **Unit Tests**: Add `TableFilteringTests` verifying filter logic, state reset behavior, and record matching.

## Impact
Enables real-time searching and filtering of conversion records across all projects and formats.
