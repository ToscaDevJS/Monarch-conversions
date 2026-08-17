# Proposal: Purge Mock Seeds & Add Table Empty State

## Problem
Currently, `ConversionSeedService` injects 24 mock conversion records into SwiftData on first run. This populates the user's dashboard with fake file conversions (`hero-banner.png`, `product-shot.jpg`, etc.) and distorts historical metrics. Additionally, `MetricsHeaderView` displays a fake hardcoded Bezier sparkline and static bar characters instead of real user data. Furthermore, `ConversionsTableView` lacks an informative empty state when no conversions have occurred.

## Proposed Solution
1. **Purge Fake Mock Seeding**:
   - Remove `ConversionSeedService.seedInitialDataIfNeeded(modelContext:)` call in `DashboardScene`.
   - Delete `ConversionSeedService.swift` and `ConversionSeedServiceTests.swift`.
   - Add a one-time cleanup/migration in `DashboardScene` or `Monarch_conversionsApp` to delete any legacy seeded records (`hero-banner.png`, `product-shot.jpg`, etc. or project "Marketing", "Storefront", etc.) so existing installations start completely clean with genuine data.
2. **Sanitize `MetricsHeaderView`**:
   - Remove the hardcoded Bezier sparkline and fake bar glyphs (`"▁▃▅▇"`).
   - Present clean, honest, and typographically polished metric cards (*Total Processed*, *Converted Today*, *Storage Saved*, *Active Projects*).
   - When no conversions exist, metrics cleanly show `0` or `0 B`.
3. **Add Table Empty State (`TableEmptyStateView`)**:
   - In `ConversionsTableView`, when `records.isEmpty` (or `filteredRecords.isEmpty`), display an empty state illustration with title, description, and an actionable button to navigate to the Convert scene (`⌘2`).
4. **Testing**:
   - Add unit tests verifying `MetricsHeaderView` and `ConversionsTableView` empty states and real aggregations.

## Impact
Transitions Monarch Conversions into a trustworthy production utility that exclusively reflects real user actions while improving first-time onboarding.
