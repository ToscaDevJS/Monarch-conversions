# Proposal: Realtime Connected Batch Status Footer

## Problem
The current footer area in `ConvertScene` stacks two redundant components (`TelemetryFooterView` and `StatusFooterView`) displaying hardcoded mock data (e.g. `"Node us-east-1a"`, `"14.2 MB/s"`, `"120ms"`, `"1 archivo"`, `"Descargas/Luminary"`). Because Monarch is a local desktop macOS app powered by CoreGraphics and ImageIO, cloud telemetry strings are misleading and disconnected from the true state of the conversion queue.

## Proposed Solution
1. **Consolidate Footers**: Replace `TelemetryFooterView` and `StatusFooterView` with a unified `BatchStatusFooterView`.
2. **Real Reactive State Binding**: Pass `items: [BatchQueueItem]`, `settings: ConversionSettings`, and `isProcessing: Bool` into the footer.
3. **Information Hierarchy**:
   - **Local Engine & Batch Summary**: Display local engine indicator (`ImageIO Local`), total file count (`items.count`), and total original byte size.
   - **Target & Destination**: Display selected target format and quality (`settings.targetFormat` · `quality%`) plus the active output directory name (with one-click Finder reveal).
   - **Real Conversion Metrics**: Compute total converted count, failed count, total saved bytes, and overall batch reduction percentage in real time.
4. **Testing**: Add unit tests for batch aggregate metric computations and update UI tests.

## Impact
Eliminates confusing mock data, saves vertical screen real estate, and provides users with immediate, accurate feedback on their batch conversion performance.
