# Proposal: Delete Conversion History & Record Management

## Problem
In the Studio/Conversions view (`ConversionsTableView`), users accumulate batch conversion records in SwiftData. Previously, there was no mechanism to clear the conversion history or delete individual records, leaving unwanted or test items permanently in the list and skewing the dashboard telemetry metrics.

## Proposed Solution
1. **Clear History Action**: Add a dedicated "Clear History" button in `ConversionsTableView` next to the table filter controls.
2. **Confirmation Dialog**: Require explicit confirmation via a native macOS `.confirmationDialog` before permanently removing all conversion records from `ModelContext`.
3. **Individual Record Deletion**:
   - Add a context menu action ("Delete Record") to individual table rows in `ConversionsTableView`.
   - Add a "Delete" button inside `ConversionDetailModalView` to allow removing a record directly while inspecting its details.
4. **Localization**: Add English and Spanish string catalogs entries for `table.clear_history`, `table.clear_history_title`, `table.clear_history_message`, `table.clear_history_confirm`, `table.delete_record`, and `action.delete`.
5. **Testing**: Add unit tests in `AppLocalizationTests` and table filtering / history verification tests.

## Rollback Plan
All changes are contained in SwiftUI views and localization string catalogs. Reverting the commits or file modifications restores the previous read-only table behavior without data migration issues.

## Impact
Enables complete history lifecycle management, keeping SwiftData persistence clean and user metrics accurate.
