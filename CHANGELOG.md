# Changelog

## 0.3.0

**Highlights**

- **Adaptive Appearance Mode:** Full dynamic Light and Dark mode support across all scenes, features, and UI components using semantic `MonarchUI.Color` tokens.

- Added adaptive Light and Dark appearance mode (`MonarchUI.Color`) with dynamic system/theme color resolution across all scenes and components
- Added `MonarchUITests` suite verifying dynamic color token initialization and appearance scheme mappings

## 0.2.0

**Highlights**

- **Full Application Localization:** Complete English (en) and Spanish (es) support across all Studio, Conversions, and Settings scenes.
- **Domain-Partitioned String Catalogs:** Refactored string resources into `Common.xcstrings`, `Conversions.xcstrings`, and `Settings.xcstrings`.

- Added full application localization support for English (en) and Spanish (es) across Studio, Conversions, and Settings views
- Added reactive locale environment propagation from UserSettings down the SwiftUI view hierarchy
- Added domain-partitioned String Catalogs (Common.xcstrings, Conversions.xcstrings, Settings.xcstrings), removing monolithic catalog
- Added AppLocalizationTests suite verifying locale mappings and string resolution across domain catalogs

## 0.1.0

**Highlights**

- **Image Conversion Pipeline:** Import and convert images with support for HEIC, JP2, and JXL formats.
- **Interactive Batch Queue:** Drag and drop files, inspect rejection details, and view full conversion records.
- **Monarch Settings:** Customize application appearance, language preferences (English/Spanish), and date formats.

- Added image import pipeline with HEIC, JP2, and JXL format support and ImageIO metadata validation
- Added interactive file dropzone and file browser dialog for batch conversions
- Added batch queue management, import rejection list, and conversion detail modal
- Added application settings scene with language selection (English/Spanish), theme appearance tokens, and functional date format options
- Added Paper design system UI styling with sharp square cards and clean dashboard layout
- Changed top navbar navigation by streamlining workspace tabs
- Fixed alignment of the settings workspace container on the left edge
