# Design: Delete Conversion History Architecture

## Architecture Overview
The deletion flow strictly obeys the vertical slicing architecture:
`DashboardScene` (Scene) -> `ConversionsTableView` / `ConversionDetailModalView` (Features) -> `ConversionRecord` (Model / SwiftData) -> `MonarchUI` (Core).

## Architecture Decisions

### 1. Direct ModelContext Deletion in View vs Dedicated ViewModel
- **Decision**: Perform SwiftData deletions directly via `@Environment(\.modelContext)` inside `ConversionsTableView` and wire callback actions in subviews.
- **Rationale**: Follows the existing codebase pattern where `ConvertScene` and `DashboardScene` use `modelContext.insert()` and `modelContext.delete()` directly with standard SwiftData macros (`@Query`, `@Environment(\.modelContext)`). Introducing an extra ViewModel layer solely for deletion would introduce unnecessary indirection.

### 2. Confirmation Dialog Pattern
- **Decision**: Use SwiftUI `.confirmationDialog` with destructive role for bulk deletion, while individual deletions via context menu or detail modal are immediate.
- **Rationale**: Bulk history clearing is a destructive, non-recoverable operation affecting all records and dashboard metrics; user confirmation prevents accidental data loss. Individual deletions are targeted actions where quick execution is expected in desktop macOS apps.

## Data Flow Diagram

```
[ User Interaction ]
        │
        ├── Click "Clear History" ──> [ Confirmation Alert ] ──(Confirm)──> [ ModelContext.delete(records) ]
        │                                                                               │
        ├── Right-click row "Delete" ───────────────────────────────────────────> [ ModelContext.delete(record) ]
        │                                                                               │
        └── Click modal "Delete" ───────────────────────────────────────────────> [ ModelContext.delete(record) ]
                                                                                        │
                                                                                        ▼
                                                                           [ SwiftData Persistent Store ]
                                                                                        │
                                                                                        ▼
                                                                             [ @Query Auto-updates ]
                                                                                        │
                                                                                        ▼
                                                                         [ Table & Metrics Re-render ]
```
