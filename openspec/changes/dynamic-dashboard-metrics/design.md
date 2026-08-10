# Design: Dynamic Dashboard Metrics

## Architecture & Data Flow

```
[SwiftData @Query private var records: [ConversionRecord]]
                            │
                            ▼
[MetricsHeaderView computed properties]
   ├─ totalProcessedCount
   ├─ workingQueueCount
   ├─ convertedTodayCount
   ├─ totalStorageSavedText
   └─ activeProjectsCount
                            │
                            ▼
               [Rendered Metric Cards]
```

## Component Architecture

1. **`MetricsHeaderView`**:
   - Uses `@Query private var records: [ConversionRecord]`
   - Formats numbers using `NumberFormatter` / `ConversionFormatting.byteSize`.

## Verification Plan
1. Unit tests in `MetricsHeaderViewTests` validating metric computations.
2. `xcodebuild test` suite execution.
