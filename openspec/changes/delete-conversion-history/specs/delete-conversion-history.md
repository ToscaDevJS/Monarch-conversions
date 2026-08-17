# Specification: Delete Conversion History & Records

## Requirements
The system MUST provide mechanisms to delete all conversion records or individual conversion records from persistent storage.

## Functional Requirements

### 1. Bulk History Deletion
- The table controls bar MUST display a "Clear History" button when records exist.
- When no records exist in the store, the "Clear History" button MUST be disabled.
- Clicking "Clear History" MUST present a confirmation dialog warning the user that the action is irreversible.
- Upon confirmation, the application MUST delete all `ConversionRecord` instances from the active `ModelContext` and persist changes immediately.

#### Scenario: Clear all conversion records
- **Given** an active conversion history with one or more records in `ModelContext`
- **When** the user clicks the "Clear History" button and confirms the action in the dialog
- **Then** all `ConversionRecord` items SHALL be removed from persistent storage and the empty table state SHALL be displayed.

#### Scenario: Clear history disabled on empty state
- **Given** an empty conversion history with 0 records
- **When** the user views the conversions table
- **Then** the "Clear History" button MUST be disabled.

### 2. Single Record Deletion
- Each row in `ConversionsTableView` MUST offer a "Delete Record" option in its context menu.
- `ConversionDetailModalView` MUST provide a "Delete" action button in its footer bar.
- Deleting an individual record MUST delete that specific `ConversionRecord` from `ModelContext`, persist changes, and close the detail modal if open.

#### Scenario: Delete single record from context menu
- **Given** a record displayed in `ConversionsTableView`
- **When** the user right-clicks the row and selects "Delete Record"
- **Then** that record MUST be deleted from the database.

#### Scenario: Delete single record from detail modal
- **Given** `ConversionDetailModalView` is open for a selected record
- **When** the user clicks "Delete"
- **Then** that record MUST be deleted and the modal MUST close.
