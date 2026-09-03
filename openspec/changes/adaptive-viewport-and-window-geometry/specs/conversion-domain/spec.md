# Delta: Adaptive Viewport Geometry, Vertical Overflow & Window Expansion

## ADDED Requirements

### Requirement: Scene-Level Vertical Scroll Containment

`ConvertScene` MUST contain its main content body (heading, columns, dropzone, queue, inspector, and settings) inside a vertical `ScrollView` so that when the window height is less than the required natural height (~868pt), all elements remain reachable via scrolling without being clipped off-screen.

#### Scenario: 30 items queued in short window
- **GIVEN** a window height of 700pt and 30 items loaded in the batch queue
- **WHEN** `ConvertScene` is rendered
- **THEN** the user can scroll vertically to access both the entire batch queue and the "Convert Batch" action button in `OutputSettingsView`

#### Scenario: Top navigation and batch status footer remain persistent
- **GIVEN** `ConvertScene` enclosed in a vertical scroll container
- **WHEN** the user scrolls the scene content vertically
- **THEN** `TopNavHeaderView` remains pinned at the top and `BatchStatusFooterView` remains pinned at the bottom

---

### Requirement: Arithmetic-Verified Minimum Window Height

`MonarchUI.Layout.minWindowHeight` MUST be set to at least 700pt, preventing window collapse below the functional threshold of standard MacBook displays while ensuring that the minimum window bounds are backed by documented arithmetic rather than arbitrary mockups.

#### Scenario: Window cannot be resized below verified vertical limit
- **GIVEN** the application window running on macOS
- **WHEN** the user attempts to resize the window height smaller than `minWindowHeight`
- **THEN** the window does not shrink below 700pt

---

### Requirement: Wide-Viewport Horizontal Layout Constraints

When the application window expands on wide monitors (width > 1440pt), scenes MUST constrain their primary content width to prevent extreme asymmetric dead space and infinite horizontal component stretching.

#### Scenario: Settings scene centers or constrains content on 2560px display
- **GIVEN** a window width of 2560pt (e.g. 27" display)
- **WHEN** `SettingsScene` is rendered
- **THEN** the settings sidebar and detail panel are contained within a maximum width container centered in the window rather than stranded on the far-left margin

#### Scenario: Convert scene output settings box width clamping
- **GIVEN** a window width of 2560pt
- **WHEN** `OutputSettingsView` is rendered in `ConvertScene`
- **THEN** the `destinationBox` does not stretch unbounded across the entire viewport width
