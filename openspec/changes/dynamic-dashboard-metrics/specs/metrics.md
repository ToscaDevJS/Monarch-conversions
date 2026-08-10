# Dynamic Dashboard Metrics Specification

## Functional Specs
1. **Processed Count**: Displays total count of `ConversionRecord` items in SwiftData context.
2. **Queue Count**: Displays count of records with status `.working` or added in last 24h.
3. **Today Count**: Displays count of records with status `.done` added today.
4. **Storage Saved**: Sums total output bytes converted and formats using `ConversionFormatting.byteSize`.
5. **Active Projects**: Counts unique `project` strings in dataset.
