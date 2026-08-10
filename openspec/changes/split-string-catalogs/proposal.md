# Proposal: Split String Catalogs by Domain

## Intent
Decompose the monolithic 1677-line `Localizable.xcstrings` file into domain-scoped String Catalogs (`Common.xcstrings`, `Conversions.xcstrings`, and `Settings.xcstrings`). This aligns with the project's vertical slicing architecture ([`ARCHITECTURE.md`](file:///Users/orlandojesus/Desktop/carpeta%20sin%20ti%CC%81tulo/Monarch-conversions/ARCHITECTURE.md)), reduces Git merge conflict risk, and improves long-term maintainability when adding new languages.

## Scope
- Create `Common.xcstrings`: Global navigation, search bar, status footers, telemetry, and common actions (`action.browse`, `action.clear_all`, `action.dismiss`).
- Create `Conversions.xcstrings`: Convert heading, batch dropzone, batch queue, Squoosh inspector, output settings, metrics header, conversions table, and detail modal.
- Create `Settings.xcstrings`: Settings heading, sidebar groups, appearance panel, language panel, and workflow panel.
- Remove monolithic `Localizable.xcstrings`.
- Update view call-sites to pass explicit `tableName` parameters matching their feature domain.
- Update `AppLocalizationTests.swift` to verify string resolution across all three domain catalogs.

## Approach
- Keep keys clean and scoped per domain.
- Use native SwiftUI `tableName: "Common"`, `tableName: "Conversions"`, and `tableName: "Settings"`.
- Validate zero regression via `xcodebuild test`.
