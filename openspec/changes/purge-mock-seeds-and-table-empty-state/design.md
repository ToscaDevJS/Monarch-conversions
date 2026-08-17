# Design: Purge Mock Seeds & Table Empty State

## Architecture

```
                               ┌────────────────────────┐
                               │     DashboardScene     │
                               └───────────┬────────────┘
                                           │
                    ┌──────────────────────┴──────────────────────┐
                    ▼                                             ▼
        ┌───────────────────────┐                     ┌───────────────────────┐
        │   MetricsHeaderView   │                     │ ConversionsTableView  │
        │  (Real computed data) │                     │   (with Empty State)  │
        └───────────────────────┘                     └───────────┬───────────┘
                                                                  │
                                                      ┌───────────┴───────────┐
                                                      │ If records.isEmpty    │
                                                      │ ➔ TableEmptyStateView │
                                                      └───────────────────────┘
```

## Component Updates

1. **Purge Seed Code**:
   - Delete `ConversionSeedService.swift` and tests.
   - In `DashboardScene.onAppear`, delete any legacy seed records (`hero-banner.png`, etc.) once if present, then never insert seeds.

2. **Clean `MetricsHeaderView.swift`**:
   - Remove `SparklineView` and ASCII glyphs.
   - Clean typographic alignment with numeric formatting.
   - Accurate storage saved: `records.reduce(0) { $0 + ($1.outputSizeBytes) }` or direct output metrics.

3. **`TableEmptyStateView.swift` / `ConversionsTableView.swift`**:
   - Centered container with `photo.stack` or `sparkles` icon.
   - Clear copy: "No Conversions Yet", "Convert files in the Convert tab to track history and savings."
   - Button: "Go to Convert (⌘2)" calling `onSelectTab?(.convert)`.
