# Proposal: App Sandbox Permission Fallback & Bookmark Management

## Problem
In macOS App Sandbox, when a user converts images with "Same as Source File" (`settings.outputDirectoryURL == nil`), `ImageConversionService` attempts to write the converted image next to the original (`sourceURL.deletingLastPathComponent()`). Because security-scoped URL access is granted only to the imported file and not its parent directory, `CGImageDestinationCreateWithURL` fails with `ConversionError.destinationCreationFailed` ("Failed to create destination image file").

## Proposed Solution
1. **Pre-flight Accessibility Check**: Determine if the destination directory is writable before initiating image destination creation.
2. **Resilient Sandbox Fallback**: If the source directory is not writable due to App Sandbox boundaries, automatically route the output destination to the user's `Downloads` folder (`~/Downloads`) or sandbox container with clean filename generation.
3. **Security-Scoped Bookmark Persistence**: For custom output directories chosen via `NSOpenPanel`, create and persist security-scoped bookmarks with `startAccessingSecurityScopedResource()` lifecycle management.
4. **UI Status & Badges**: Inform the user when fallback occurs with an informative badge/label in the batch item row or detail view.
5. **Unit Tests**: Validate writable directory detection, fallback routing, and bookmark management via Swift Testing.

## Impact
Eliminates destination creation failures and ensures zero aborted conversions for sandboxed image batches.
