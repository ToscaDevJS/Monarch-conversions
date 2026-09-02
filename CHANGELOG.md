# Changelog

## 0.27.0

**Highlights**

- **Responsive Surface Layouts & Honest Window Floor (1180×600):** Eliminated rigid window and surface overflow bugs across the app. Raised declared minimum window dimensions to an honest 1180×600 floor derived from arithmetic requirements across all three live surfaces (`Settings`, `Dashboard`, and `Convert`), removing duplicate root window constraints and preventing content from silently clipping or overflowing.
- **Shared Table Geometry & Two-Axis Dashboard Scrolling:** Centralized table column dimensions under `MonarchUI.Layout.TableColumn` to ensure table headers and rows agree by construction. Placed table header and rows inside a unified horizontal `ScrollView` with fixed content width (1349pt) and nested vertical scroll, ensuring the `Added` column and right-side metadata remain reachable on narrow viewports without header drift.
- **Convert Surface Negotiation & Output Settings Reflow:** Replaced rigid 460pt left column with a flexible negotiating column (`minWidth: 380`, `idealWidth: 460`, `maxWidth: 520`). Refactored output settings controls into a reusable `OutputSettingBox` component, leveraging `ViewThatFits` to automatically reflow between a single wide row and a compact two-row layout.
- **Bilingual & Localization Text-Fitting Hardening:** Added explicit text fitting policies for Spanish expansion across dense controls: two-line wrapping with intrinsic vertical growth in `SettingsSidebarView` and `AppearancePanelView`, explicit single-line truncation in `LanguagePanelView`, table headers, and `BatchQueueView`, and multiline wrapping in `BatchDropzoneView`.
- **Layout Invariant Regression Test Suite:** Introduced `LayoutInvariantTests.swift` guarding arithmetic invariants across Settings, Dashboard viewport, table column totals, and Convert compact reflow boundaries.

- Centralized shared layout constants in `MonarchUI.Layout` (`minWindowWidth: 1180`, `minWindowHeight: 600`, `scenePadding: 28`, `Settings`, `TableColumn`, `Convert`)
- Removed redundant `.frame(minWidth:minHeight:)` on `RootView`'s `ZStack`, keeping scene-level window sizing as the single source of truth
- Wrapped `ConversionsTableView` header and rows in a horizontal `ScrollView` with deterministic 1349pt content width and nested vertical scrolling for rows
- Refactored `OutputSettingsView` to use `ViewThatFits(in: .horizontal)` and extracted `OutputSettingBox`
- Added text fitting modifiers (`.lineLimit`, `.truncationMode`, `.fixedSize`) across Settings, Table headers, and Convert dropzone/queue views
- Added `LayoutInvariantTests.swift` guarding window floors, table scroll requirement, and Convert card geometry from shared constants
- Stabilized `BatchQueueStatusUITests` with deterministic navigation and window handling; full test suite passing with 0 regressions (103 unit tests, 7 UI tests)

## 0.26.0

**Highlights**

- **Fix EXIF Orientation Double-Rotation Bug & Metadata Synchronization (Strict TDD):** Fixed critical double rotation issue during image resizing where `CGImageSourceCreateThumbnailAtIndex` with `WithTransform: true` rotates pixel buffers while previously copied metadata retained orientation tags (e.g., orientation 6 / 90° CW). Output properties are now properly normalized to orientation 1 (`.up`) across root and TIFF dictionaries on resize, unrotated raw pixels preserve original tags on standard conversions, and EXIF/GPS metadata is stripped when disabled.
- **SDD Specification Completeness:** Formalized and verified OpenSpec artifacts under `openspec/changes/fix-exif-orientation-double-rotation/` with 100% test pass rate (105 tests) and zero regressions.

- Normalized `kCGImagePropertyOrientation` and `{TIFF}.Orientation` to 1 when resizing with transform in `ImageConversionService.swift`
- Added test fixture `sample_orientation_6.jpg` containing EXIF orientation, TIFF make/model, GPS coordinates, and user comment
- Added comprehensive unit tests in `ImageConversionServiceTests.swift` verifying normalized orientation on resize, orientation retention without resize, and metadata stripping
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.25.0

**Highlights**

- **Strict TDD Domain Coverage for Import Outcomes:** Added dedicated unit test suite for `ImportOutcome` discriminated union enum (`.accepted` / `.rejected`), validating payload extraction, all rejection reason variants, Equatable value comparison, and Sendable concurrency safety across task boundaries.
- **SDD Specification Completeness:** Formalized and verified OpenSpec artifacts under `openspec/changes/import-outcome-tests/` with 100% test pass rate and zero regressions.

- Added `ImportOutcomeTests.swift` covering all enum cases and payload extractions
- Added Equatable equality and inequality verification across distinct variants
- Added async Sendable cross-boundary isolation tests
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.24.0

**Highlights**

- **DNG / RAW Image Import & Conversion Support (Strict TDD):** Added native support for importing and converting Digital Negative (DNG / Apple ProRAW) camera photos directly into web-optimized formats (JPG, PNG, WebP, AVIF, HEIC, TIFF) verified via strict Red-Green-Refactor TDD cycle.

- Added `.dng` case and file extension mapping to `ImageFormat.swift`
- Configured DNG as decode-only (input format) in `outputEligibleCases`
- Added DNG content type support to `ImageImportService.swift`
- Added unit tests for ProRAW/DNG decoding and conversion in `ImageImportServiceTests.swift` and `ImageConversionServiceTests.swift`
- Completed full OpenSpec SDD change artifacts under `openspec/changes/dng-raw-import-support/`
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.23.0

**Highlights**

- **Conversion History Purge & Item Deletion:** Added dedicated "Clear History" action with confirmation dialog in the Studio conversions table, right-click context menu single record deletion, modal footer deletion, and full bilingual localization support.

- Added "Clear History" button with `.confirmationDialog` in `ConversionsTableView.swift`
- Added "Delete Record" option to table row context menu
- Added "Delete" action button to `ConversionDetailModalView.swift`
- Added localization keys to `Conversions.xcstrings` and `Common.xcstrings`
- Completed full OpenSpec SDD change artifacts under `openspec/changes/delete-conversion-history/`
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.22.0

**Highlights**

- **Technical Inspector Modal Redesign:** Replaced legacy mock progress states with a sleek macOS Quick-Look style inspection card featuring real metadata, live image preview, outward drag-and-drop (`.onDrag`), exact file specs, and direct action shortcuts.

- Redesigned `ConversionDetailModalView.swift` with live thumbnail preview and outward drag
- Added 2x2 technical specification grid (Transformation, Resolution, Output Size, Processed Date)
- Added direct action buttons: "Reveal in Finder", "Copy File", "Copy ID", and "Close" (`Esc`)
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.21.0

**Highlights**

- **Dashboard Table Drag-and-Drop & Column Spacing:** Enabled outward drag-and-drop (`.onDrag`) directly from completed conversion history rows into external apps and Finder, added quick context menu actions (Copy File, Reveal in Finder, Copy ID), and added whitespace padding between table columns to prevent text clipping.

- Added `outputFilePath` and `outputURL` properties to `ConversionRecord`
- Added `.onDrag` and rich `.contextMenu` to `TableRowView` in `ConversionsTableView`
- Added right column padding between file name, dimensions, and output columns
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.20.0

**Highlights**

- **Outward Drag & Drop and Direct Export:** Enabled outward drag-and-drop (`.onDrag`) directly from conversion queue items and the inspector view into Finder, Photoshop, Figma, Slack, or Mail using native `NSItemProvider`. Added clipboard file-copy actions to context menus.

- Added `BatchQueueItem.dragItemProvider` with unit test coverage
- Added `.onDrag` provider to `BatchQueueItemRow` and `SquooshInspectorView`
- Added "Copy Converted File" and "Copy Source File" context menu actions
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.19.0

**Highlights**

- **Native About Monarch Panel & Menu Command:** Added a dedicated About Monarch panel in Settings and hooked up the native macOS Application Menu `About Monarch` command with official AppIcon branding, dynamic versioning, privacy guarantee, and repository links.

- Added `AboutPanelView.swift` in Settings featuring privacy guarantees and resource links
- Integrated `CommandGroup(replacing: .appInfo)` in `Monarch_conversionsApp.swift`
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.18.0

**Highlights**

- **Official Production App Iconography:** Generated and integrated the official Monarch icon set across all 10 required macOS resolutions (16x16 up to 1024x1024 / 512@2x) with dark obsidian squircle and luminous faceted prism butterfly branding.

- Added full PNG icon resolution set to `AppIcon.appiconset`
- Updated `AppIcon.appiconset/Contents.json` asset mappings
- Verified asset catalog compilation and full test suite pass: 100% tests passing with 0 regressions

## 0.17.0

**Highlights**

- **Production App Sandbox & App Store Entitlements:** Created dedicated `Monarch-conversions.entitlements` configuring `com.apple.security.files.user-selected.read-write` and `com.apple.security.files.bookmarks.app-scope`, enabling seamless output directory writing and persistent security-scoped folder access.
- **Mac App Store Metadata:** Configured production category `public.app-category.graphics-design`, display name `Monarch`, and human-readable copyright in build configurations.

- Added `Monarch-conversions/Monarch-conversions.entitlements`
- Configured `CODE_SIGN_ENTITLEMENTS` in project build settings
- Verified clean build and full test suite pass: 100% tests passing with 0 regressions

## 0.16.1

**Highlights**

- **Table Column Wrapping Fix & Compact ID Formatting:** Prevented multi-line text breaking on hyphenated UUIDs by implementing a compact 8-character monospaced identifier representation with full UUID tooltip help and enforcing strict single-line truncation across all table cells.

- Added `ConversionFormatting.shortFileId` helper with full unit test coverage
- Added `.lineLimit(1)`, `.truncationMode(.middle)`, and `.help(record.fileId)` to table cells and detail modal headers
- Consolidated UI automation test suite to single app instance
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.16.0

**Highlights**

- **Purged Mock Seeds & Honest Data Pipeline:** Removed `ConversionSeedService` and mock dataset injection, ensuring the application database exclusively records authentic user conversions. Added an automatic migration cleaner for legacy mock records.
- **Sanitized Metrics Header:** Removed fake Bezier sparkline and static ASCII glyphs, presenting clean, typographic, real-time statistics.
- **Interactive Table Empty State:** Added a dedicated empty state with direct shortcut navigation (`⌘2`) to the conversion studio when no history exists or filters yield 0 results.

- Removed `ConversionSeedService.swift` and `ConversionSeedServiceTests.swift`
- Cleaned `MetricsHeaderView.swift` with genuine aggregation properties
- Added `TableEmptyStateView` in `ConversionsTableView.swift`
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.15.1

**Highlights**

- **UI Dropdown Chevron Cleanup:** Removed duplicate disclosure chevron arrows across dashboard table filter selectors and output settings menus, restoring clean native macOS borderless styling.

- Removed manual `Image(systemName: "chevron.down")` from `FilterLabel` in `ConversionsTableView.swift`
- Removed hardcoded unicode `" ⌄"` characters from all 5 menu labels in `OutputSettingsView.swift`
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.15.0

**Highlights**

- **Realtime Connected Batch Status Footer:** Replaced disconnected fake cloud mock footers with a unified `BatchStatusFooterView` providing live batch statistics, local ImageIO engine status, output directory reveal button, and accurate storage savings telemetry.
- **Removed Cloud Mocks:** Completely removed obsolete `TelemetryFooterView` and `StatusFooterView` files and static dummy mock metrics.

- Added `BatchStatusFooterView` bound to queue items, conversion settings, and processing state
- Added unit test suite `BatchStatusFooterTests` covering empty, active, and completed batch queues
- Cleaned up scene layouts across `ConvertScene`, `DashboardScene`, and `SettingsScene`
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.14.0

**Highlights**

- **Keyboard Shortcuts & Power User Navigation:** Added full macOS keyboard shortcuts for rapid batch operations (`⌘O` for file import, `⌘R`/`⌘↵` for batch conversion, `⌘⌫` for removing selected queue items, and `⌘K` for clearing the queue).
- **Global Tab Navigation & Menu Bar Integration:** Added `⌘1` (Studio), `⌘2` (Convert), and `⌘3` (Settings) tab switching and integrated native macOS `SidebarCommands()`.

- Added scene-level keyboard shortcuts (`⌘O`, `⌘R`, `⌘↵`, `⌘⌫`, `⌘K`) in `ConvertScene.swift`
- Added global scene switching shortcuts (`⌘1`, `⌘2`, `⌘3`) in `RootView.swift`
- Added native macOS menu commands with `SidebarCommands()` in `Monarch_conversionsApp.swift`
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.13.0

**Highlights**

- **Reveal in Finder Action for Converted Files:** Added one-click "Reveal in Finder" quick action button and context menu on converted batch items, instantly selecting the output file in macOS Finder using `NSWorkspace.shared.activateFileViewerSelecting`.
- **Output File URL Tracking:** Added `outputFileURL: URL?` property to `BatchQueueItem` with end-to-end propagation from `ImageConversionResult.outputURL`.

- Added `outputFileURL: URL?` property to `BatchQueueItem` and wired result URLs in `ConvertScene.processBatchConversion`
- Added `"reveal-in-finder-button"` action button to `BatchQueueItemRow` when item status is `.done`
- Added `.contextMenu` on `BatchQueueItemRow` supporting "Reveal in Finder" for converted outputs and "Show Source in Finder" for sources
- Added unit tests in `BatchQueueItemTests` and UI tests in `BatchQueueStatusUITests`
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.12.0

**Highlights**

- **App Sandbox Write Permission Fallback & Security-Scoped Bookmark Management:** Implemented pre-flight write accessibility checks in `ImageConversionService` with automatic and seamless fallback to `~/Downloads` for sandboxed conversion batches.
- **Visual Fallback Indicators:** Added "✓ Done · Downloads" fallback status badge in `BatchQueueItemRow` and propagated fallback state across batch pipelines.

- Implemented pre-flight writable check and resilient fallback cascade to `~/Downloads` (and temporary directory) when write permission is not granted on source parent directory under App Sandbox
- Added security-scoped resource bracketing (`startAccessingSecurityScopedResource()` / `stopAccessingSecurityScopedResource()`) for custom output directories
- Added `wasFallback: Bool` property to `ImageConversionResult` and `isFallbackDestination: Bool` to `BatchQueueItem`
- Added comprehensive unit tests in `ImageConversionServiceTests` covering writable and non-writable directory routing
- Stabilized macOS UI test lifecycle in `BatchQueueStatusUITests` with explicit app teardown
- Verified full test suite pass: 100% tests passing with 0 regressions

## 0.11.0

**Highlights**

- **Swift 6 Strict Concurrency & Actor Isolation:** Resolved actor isolation and concurrency warnings across conversion models, services, views, and test suites with explicit `@MainActor` annotations.
- **Robust macOS UI Testing Architecture:** Added direct scene routing via `-ui-testing-convert` launch argument and stable accessibility identifiers (`batch-dropzone`, `browse-files-button`, `batch-queue`, `nav-convert`) to ensure deterministic XCTest execution on macOS.

- Resolved Swift 6 `@MainActor` warnings in `ImageImportService`, `ImageFilePicker`, conversion domain models, format utilities, and test suites
- Refactored `BatchQueueStatusUITests` to remove brittle `app.windows.firstMatch` dependency and validate explicit accessibility components directly
- Added direct scene routing in `AppRouter` for isolated UI test execution
- Verified full test suite pass: 69/69 tests passing with 0 Xcode build warnings

## 0.10.0

**Highlights**

- **Real-Time Batch Queue Status Indicators:** Each item in the batch conversion queue now shows its individual processing status — spinner while converting, green checkmark when done, red cross on failure.

- Added `BatchItemStatus` enum (`.queued`, `.converting`, `.done`, `.failed`) with live status progression in the batch conversion pipeline
- Added visual status badges in `BatchQueueItemRow` — `ProgressView` spinner for converting, green "✓ Done" checkmark, and red "✕ Failed" cross
- Added 11 unit tests in `BatchQueueItemStatusTests` covering all status transitions, pipeline progression, and badge rendering logic
- Added `statusRed` semantic color token to `MonarchUI.Color` for failure state indicators

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
