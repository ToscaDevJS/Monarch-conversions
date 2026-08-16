# Proposal: Keyboard Shortcuts & Native macOS Menu Bar Commands

## Problem
Power users and professionals operating batch conversions in macOS expect first-class keyboard navigation and standard macOS menu bar shortcuts (such as `⌘O` to import files, `⌘R`/`⌘↵` to run batch conversions, `⌘⌫` to remove selected items, `⌘K` to clear queue, and `⌘1`/`⌘2`/`⌘3` to switch scenes). Currently, all interactions require pointer clicks.

## Proposed Solution
1. **Scene Keyboard Shortcuts**:
   - In `ConvertScene.swift`, attach `.keyboardShortcut("o", modifiers: .command)` to file import.
   - Attach `.keyboardShortcut("r", modifiers: .command)` and `.keyboardShortcut(.return, modifiers: .command)` to trigger batch conversion.
   - Attach `.keyboardShortcut(.delete, modifiers: .command)` to remove the selected queue item.
   - Attach `.keyboardShortcut("k", modifiers: .command)` to clear queue.
2. **Global Navigation Shortcuts**:
   - Add `⌘1` (Studio), `⌘2` (Convert), and `⌘3` (Settings) tab switching shortcuts in `RootView` and TopNav.
3. **macOS Native App Commands**:
   - Add `.commands` in `Monarch_conversionsApp.swift` with standard File and View menu entries dispatching notification or focused values.
4. **Testing**:
   - Add unit and UI tests verifying keyboard shortcut accessibility and selection removal.

## Impact
Dramatically increases workflow speed and brings Monarch in full alignment with Apple Human Interface Guidelines for macOS desktop utility apps.
