# Changelog

## 0.9.0

**Highlights**

- **Output Destination Folder Picker:** Added Destination Folder `Menu` control box in `OutputSettingsView` integrated with `NSOpenPanel` for choosing custom export directories.

## 0.8.0

**Highlights**

- **Real Image Inspector Preview:** `SquooshInspectorView` loads and renders actual `NSImage` instances from `BatchQueueItem.fileURL` in the interactive split comparison slider, with fallback badges for unreadable files.

## 0.7.0

**Highlights**

- **Dynamic Dashboard Metrics:** Connected `MetricsHeaderView` to SwiftData `@Query` for real-time calculation of processed images, working queue, items converted today, total storage saved, and active projects count.

## 0.6.0

**Highlights**

- **Global Search Integration & ⌘K Shortcut:** Real-time query filtering across filenames, IDs, formats, and projects in `GlobalSearchBarView` with keyboard shortcut focus (`⌘K`).
- **Functional System Actions:** Integrated `NSPasteboard` clipboard copying ("Copy name"), `NSWorkspace` file launching ("Open original"), and `ESC` key modal dismissal.

## 0.5.0

**Highlights**

- **Interactive Table Dropdown Filters:** Integrated interactive `Menu` controls in `ConversionsTableView` for Status (Working/Done), Input Format, Output Format, and Project.
- **Filtering State & Reset:** Real-time array predicate filtering via `TableFilterState` with single-click reset capability.

## 0.4.0

**Highlights**

- **Core Image Conversion Engine:** High-performance asynchronous image processing service (`ImageConversionService`) built on macOS ImageIO (`CGImageSource` and `CGImageDestination`).
- **Interactive Output Settings:** Direct binding of target formats (JPEG, PNG, WebP, AVIF, HEIC, TIFF), lossy compression quality, dimension constraints, and EXIF metadata stripping.
- **SwiftData Batch Pipeline:** Automatic persistence of batch `ConversionRecord` items in SwiftData `ModelContext` upon conversion completion.

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
