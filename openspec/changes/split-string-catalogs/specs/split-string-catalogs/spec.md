# Specification: Split String Catalogs by Domain

## Requirements

### SC-1: Domain String Catalogs Creation
The project MUST replace `Localizable.xcstrings` with three domain-specific String Catalogs: `Common.xcstrings`, `Conversions.xcstrings`, and `Settings.xcstrings`.

### SC-2: Explicit Table Mapping
View call-sites MUST specify the corresponding `tableName` parameter matching their architectural domain (`"Common"`, `"Conversions"`, or `"Settings"`).

### SC-3: Monolithic File Removal
`Localizable.xcstrings` MUST be completely deleted from the codebase.

### SC-4: Verification Tests
`AppLocalizationTests.swift` MUST test string resolution against each of the three domain tables in both English (`en`) and Spanish (`es`).
