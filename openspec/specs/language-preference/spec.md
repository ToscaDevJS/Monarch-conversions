# Language Preference Capability Spec

## Requirements

### Requirement: Language Selection Options
The application MUST allow the user to select between English (`en`) and Spanish (`es`) display languages.

#### Scenario: Selection of English
- **GIVEN** the application settings view is active
- **WHEN** the user selects English
- **THEN** the language setting updates to English

#### Scenario: Selection of Spanish
- **GIVEN** the application settings view is active
- **WHEN** the user selects Spanish
- **THEN** the language setting updates to Spanish

### Requirement: Language Persistence
Selected language MUST be persisted in `UserDefaults` and restored upon app initialization.

#### Scenario: Restoration upon app launch
- **GIVEN** Spanish was previously selected and stored
- **WHEN** the application starts up
- **THEN** Spanish is loaded as the active language setting

### Requirement: Global Locale Propagation
The root application view MUST inject the active language `Locale` into the SwiftUI environment.

#### Scenario: Environment locale update
- **GIVEN** user changes language preference
- **WHEN** setting changes
- **THEN** `.environment(\.locale, ...)` updates immediately

### Requirement: Accessibility Integration
Language selection UI controls MUST provide explicit VoiceOver accessibility labels, hints, and traits.

#### Scenario: VoiceOver readout of language picker
- **GIVEN** VoiceOver is enabled
- **WHEN** inspecting the language selection field
- **THEN** current language, action hint, and picker traits are announced
