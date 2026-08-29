# Delta for Queue Scroll View, Window Constraints & Tab State Preservation

## ADDED Requirements

### Requirement: Scrollable Batch Queue Container

The batch queue list view MUST be enclosed within a scrolling viewport so that adding large numbers of files does not overflow or displace controls from the view.

#### Scenario: 50 items in queue renders inside scroll container
- **GIVEN** a batch containing 50 items
- **WHEN** rendered in `BatchQueueView`
- **THEN** items are presented in a `ScrollView` without pushing the footer or inspector out of frame

### Requirement: Tab Navigation State Preservation

When navigating away from the Convert scene to Dashboard or Settings and returning, the queued items, selected items, rejections, and ongoing conversion tasks MUST be preserved intact.

#### Scenario: Tab switch retains queue items
- **GIVEN** a conversion queue with 5 items
- **WHEN** user navigates to Dashboard and then back to Convert
- **THEN** all 5 items remain in the queue with their current statuses intact

### Requirement: Window Minimum Sizing Limits

The main application window MUST enforce a minimum width of at least 860pt and a minimum height of at least 600pt to prevent two-column layout compression.

#### Scenario: Window cannot shrink below minimum bounds
- **GIVEN** the application window
- **WHEN** resized by the user
- **THEN** width does not shrink below 860pt and height does not shrink below 600pt
