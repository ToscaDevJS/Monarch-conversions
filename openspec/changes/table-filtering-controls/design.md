# Design: Interactive Table Filtering & Reset Controls

## Architecture & Data Flow

```
[Filter Menus (Status, Input, Output, Project)] ──► [FilterState (@State in ConversionsTableView)]
                                                            │
                                                            ▼
[SwiftData @Query private var records: [ConversionRecord]] ──► [filteredRecords computed property]
                                                            │
                                                            ▼
                                                [Rendered TableRows]
```

## Component Architecture

1. **`TableFilterState`**:
   - Encapsulates filter choices:
     - `status: ConversionStatus?` (nil = All)
     - `inputFormat: ImageFormat?` (nil = All)
     - `outputFormat: ImageFormat?` (nil = All)
     - `project: String?` (nil = All)
   - `var isActive: Bool` (true if any filter is non-nil)
   - `mutating func reset()`

2. **Interactive Dropdowns**:
   - `Status`: All, Working, Done
   - `Input Format`: All, PNG, JPG, WebP, AVIF, HEIC, TIF, JP2, JXL
   - `Output Format`: All, PNG, JPG, WebP, AVIF, HEIC, TIF, JP2
   - `Project`: All + dynamically collected unique project names from `records`

3. **Reset Button**:
   - Active when `filterState.isActive == true`.
   - Clears all filters back to `.all`.

## Verification Plan
1. Unit tests in `TableFilteringTests` verifying record filtering logic across single and combined criteria.
2. `xcodebuild test` suite execution.
