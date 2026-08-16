# Delta for Realtime Connected Batch Status Footer

## ADDED Requirements

### Requirement: Unified Realtime Batch Status Footer

`ConvertScene` MUST display a single, synchronized `BatchStatusFooterView` displaying real-time metrics derived directly from `items`, `conversionSettings`, and `isProcessing`.

#### Scenario: Empty queue state
- **GIVEN** `items` is empty and `isProcessing == false`
- **WHEN** `BatchStatusFooterView` is rendered
- **THEN** it displays `"0 files · 0 B"`, the target format/quality, and status `"Ready"`

#### Scenario: Active conversion state
- **GIVEN** a queue with items undergoing conversion (`isProcessing == true`)
- **WHEN** `BatchStatusFooterView` is rendered
- **THEN** it displays an active progress indicator with the current processing count (`"Converting X of Y..."`)

#### Scenario: Completed conversion summary
- **GIVEN** items with status `.done`
- **WHEN** batch completes
- **THEN** it computes and displays the count of done items, total bytes saved, and total reduction percentage

### Requirement: Removal of Fake Cloud Telemetry

All mock references to `"Node us-east-1a"`, network throughput (`"14.2 MB/s"`), network latency (`"120ms"`), and mock cloud endpoints MUST be permanently removed from the application footer.
