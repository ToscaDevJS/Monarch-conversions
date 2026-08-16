# Delta for Keyboard Shortcuts & Native macOS Menu Bar Commands

## ADDED Requirements

### Requirement: Convert Scene Keyboard Shortcuts

`ConvertScene` MUST support standard macOS keyboard shortcuts for frequent operations:
- `⌘O` to open file browser.
- `⌘R` or `⌘↵` to execute batch conversion.
- `⌘⌫` (Command + Backspace) to remove the selected queue item.
- `⌘K` (Command + K) to clear the entire queue.

#### Scenario: Open file picker shortcut
- **GIVEN** `ConvertScene` is active
- **WHEN** user presses `⌘O`
- **THEN** the native file picker is invoked

#### Scenario: Start batch shortcut
- **GIVEN** queued items in `ConvertScene`
- **WHEN** user presses `⌘R` or `⌘↵`
- **THEN** `processBatchConversion()` starts

#### Scenario: Delete selected item shortcut
- **GIVEN** a queue item is selected
- **WHEN** user presses `⌘⌫`
- **THEN** the selected item is removed from `items` and selection is updated

### Requirement: Tab Navigation Shortcuts

The application root and top navigation MUST support `⌘1` (Studio), `⌘2` (Convert), and `⌘3` (Settings) shortcuts to immediately switch between main application scenes.

#### Scenario: Switch tab via shortcut
- **GIVEN** `RootView` is displayed
- **WHEN** user presses `⌘2`
- **THEN** `router.navigateTo(.convert)` is executed
