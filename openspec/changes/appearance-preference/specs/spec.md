# Appearance Preference Spec Delta

## ADDED Requirements

### Requirement: User Preference Selection
The application MUST allow the user to select between three appearance modes.

#### Scenario: Selection of Dark Mode
- **GIVEN** the app is open
- **WHEN** user selects Dark
- **THEN** dark mode is active

#### Scenario: Selection of Light Mode
- **GIVEN** the app is open
- **WHEN** user selects Light
- **THEN** light mode is active

### Requirement: Preference Persistence
Selected appearance preference MUST be saved to `UserDefaults` and restored upon app startup.

#### Scenario: Persistence across launch
- **GIVEN** preference is set to Light
- **WHEN** app restarts
- **THEN** Light appearance is restored

### Requirement: UI Synchronization
Changing the appearance selection in `AppearancePanelView` MUST update the global root `.preferredColorScheme()` immediately without requiring an app restart.

#### Scenario: Real-time update
- **GIVEN** setting is changed
- **WHEN** clicked
- **THEN** preferredColorScheme updates immediately

### Requirement: Accessibility
Appearance selection controls MUST expose clear accessibility labels and hints for VoiceOver.

#### Scenario: VoiceOver readout
- **GIVEN** VoiceOver is running
- **WHEN** inspecting card
- **THEN** label and selection traits are read
