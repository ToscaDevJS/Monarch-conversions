# Launch Triage

**Monarch Conversions** · v0.25.0 (build 25) · commit `287ac87` · 29 Aug 2026

Sixteen defects found by reading the code and running it, ordered by what they cost the person
using the app. Every item was verified directly — the file and line are named so each one can be
checked independently.

---

## Verdict

**The app is not ready to launch, and the test suite is not reporting that.**

The Release build is clean and 84 unit tests pass. That is real. But four defects destroy the
user's data, the before/after slider on the main screen shows the same image twice, and the app
cannot be built by anyone but its author — there is no shared Xcode scheme. The green checkmarks
are measuring the parts that already work.

| Signal | Result | Note |
|---|---|---|
| Unit tests | 84 / 84 passing | Genuinely passing; executed during the audit |
| UI tests | 1 failing | Fails 3 of 3 runs — not flaky |
| Release build | Clean | 0 errors, 1 benign AppIntents warning |
| Data-loss defects | 4 | All in shipping code paths |

---

## Tier 1 — Destroys user data

Fix these before anyone else runs the app. Not crashes, not rough edges — these four silently
delete or overwrite things the user cannot get back.

### 01. The Dashboard deletes real history every time it opens

`Scenes/Dashboard/DashboardScene.swift:61` — called from `.onAppear` at `:57`

`cleanLegacySeedsIfNeeded()` runs on every appearance and deletes any record whose project is
`"Marketing"`, `"Storefront"`, `"Brand"` or `"Events"`, or whose filename is one of eight demo
names — `hero-banner.png`, `product-shot.jpg`, `team-photo.png`, `launch-grid.jpg`, and four more.

These are ordinary filenames. A designer who converts `team-photo.png` loses that entry from their
history the next time they visit the Dashboard, permanently, with no message. This is leftover
demo-seed cleanup that shipped into production.

**Fix** — Delete the function and its `.onAppear` call. The mock seeds were already purged in
0.16.0; this is cleanup for data that no longer exists.

### 02. Converted files silently overwrite each other

`Features/Conversions/Services/ImageConversionService.swift:134`

The output path is always `{name}_converted.{ext}` with no uniquing and no existence check.
Converting `logo.png` and `logo.jpg` to PNG in one batch means the second destroys the first.
Re-running any batch overwrites the previous results. If the user already has a file with that
name, it is gone.

**Fix** — Check `FileManager.fileExists` and append `-1`, `-2` … before writing. Roughly eight
lines, and the single highest-value fix in this document.

### 03. A failed database open wipes the entire history

`App/Monarch_conversionsApp.swift:16` → `:31`

If `ModelContainer` fails to open — which is exactly what a schema change causes when the next
version ships — `removeDefaultStoreFiles()` deletes `default.store` and its journal files and
retries. No prompt, no backup, no message. The user's entire conversion history disappears because
a field was added.

If that retry also fails, line 25 calls `fatalError` and the app crashes on launch instead of
degrading.

**Fix** — Move the store aside instead of deleting it, tell the user what happened, and replace the
`fatalError` with the in-memory container already built one line above.

### 04. Re-running a batch duplicates every history row

`Scenes/Convert/ConvertScene.swift:75`

`processBatchConversion` loops over every item with no filter on status. Pressing Convert twice
re-converts every already-finished file and inserts it into SwiftData again as a new
`ConversionRecord`. The Dashboard fills with duplicates, and the saved-bytes metrics count the same
file repeatedly.

**Fix** — Iterate only items where `status == .queued`.

---

## Tier 2 — Makes the app feel broken

Nothing here loses data, but each one teaches the user that the app cannot be relied on. Two are
one-line fixes.

### 05. SVG is offered as an output format and always fails

`Features/Conversions/Models/ImageFormat.swift:22` · `Services/ImageConversionService.swift:74`

`outputEligibleCases` filters out `.webp`, `.jpegXL` and `.dng` — but not `.svg`. So SVG appears in
the format menu. Meanwhile `uti(for:)` returns `nil` for SVG, so every single file throws.

The user picks SVG, converts fifty images, and gets fifty red failures with no explanation. The
comment directly above that filter states it exists so output pickers "never accidentally offer
them." SVG is the one that slipped through.

**Fix** — Add `&& $0 != .svg` to the filter. One expression. Then add the test that would have
caught it: `ImageFormatTests` checks webp, jxl and dng but never svg.

### 06. The before/after slider compares the image to itself

`Scenes/Convert/ConvertScene.swift:179`

`SquooshInspectorView` receives `imageURL: selectedItem?.fileURL` — the source file — and renders
that same URL on both sides of the split. The headline feature of the Convert screen, the thing
that justifies the whole layout, shows the identical picture twice.

The converted file's path already exists as `outputFileURL`, populated at line 92. It is simply
never passed in. The labels are hardcoded too: `"WEBP OPTIMIZED"` and `"ORIGINAL (PNG)"` regardless
of the real formats, while the correctly-computed `targetFormatText` is passed in and never used.

**Fix** — Pass both URLs and render the output on the optimized side. Wire up the
`targetFormatText` already being handed to the view.

### 07. Clearing the queue mid-conversion crashes the app

`Scenes/Convert/ConvertScene.swift:75`, `:129`

The loop captures `items.indices` once, then reads `items[index]` after every `await`. Clear All is
never disabled during processing, and ⌘K and ⌘⌫ stay live. Shrinking the array mid-batch makes the
next index access trap — a hard crash, no recovery.

**Fix** — Disable the destructive actions while `isProcessing`, and iterate by item id rather than
index.

### 08. The window freezes for the entire batch

Build settings · `Services/ImageConversionService.swift:87`

The project sets `SWIFT_APPROACHABLE_CONCURRENCY = YES` and
`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`. Under that mode a `nonisolated async` function
*inherits its caller's isolation* instead of hopping off it. And `convert` contains no suspension
points at all — every `CGImageSource` and `CGImageDestination` call is synchronous.

So the whole conversion runs on the main thread. The progress spinner cannot even animate while it
works. There is no `Task.detached` and no `@concurrent` anywhere in the app.

**Fix** — Mark the conversion work `@concurrent`, or dispatch it through `Task.detached`, and hop
back to the main actor only to update the item.

### 09. Errors never reach the person using the app

`Scenes/Convert/ConvertScene.swift:111` — zero `.alert(` in the codebase

`ConversionError` has six well-written user-facing messages. All six go to `print()`. The user sees
a red `✕ Failed` pill with no reason, no tooltip and no retry. There is not a single alert or error
sheet in the entire app.

There is also no way to cancel: no stored task handle, no cancellation check anywhere. A fifty-file
batch can only be stopped by force-quitting.

**Fix** — Store the error on the queue item and surface it in the row plus a detail view. Then add
a Cancel button backed by the `Task` handle already created.

### 10. The queue cannot scroll, and the window has no minimum size

`Features/Conversions/Views/BatchQueueView.swift:35` · `App/Monarch_conversionsApp.swift:42`

The batch queue is a plain `VStack` with no scroll container. The import limit is fifty files —
everything past the fold is unreachable.

And `WindowGroup` declares no `minWidth`, `defaultSize` or `windowResizability`. The Convert layout
needs roughly 1375pt and the Dashboard table roughly 1285pt, neither inside a horizontal scroll
view. Dragging the window narrower makes the columns overlap.

**Fix** — Wrap the queue in a `ScrollView` with a `LazyVStack`, and give the window a `defaultSize`
and a `minWidth` matching the real layout floor.

### 11. Settings and the queue are lost on every tab switch

`App/RootView.swift:15` · `Scenes/Convert/ConvertScene.swift:9`

`RootView` switches scenes inside a `Group`, which destroys `ConvertScene` and all of its `@State`
when the tab changes. Pressing ⌘1 then ⌘2 loses the queue, target format, quality, dimensions and
chosen output folder. Quitting loses them too — only appearance and language are persisted.

The output folder can never survive a relaunch anyway: the `bookmarks.app-scope` entitlement is
granted but `bookmarkData` appears nowhere in the codebase.

**Fix** — Lift the conversion settings and queue into a shared `@Observable` model owned by
`RootView`, and persist the output folder as a security-scoped bookmark. The entitlement is already
there and unused.

---

## Tier 3 — Blocks distribution

Independent of code quality. These stop the app from reaching a second machine at all.

### 12. The deployment target excludes almost every Mac

`project.pbxproj` — `MACOSX_DEPLOYMENT_TARGET = 26.5`

This sets `LSMinimumSystemVersion` to 26.5, so the app refuses to launch on any Mac not running
that exact point release or newer. Nothing in the code needs it — it is plain SwiftUI, SwiftData,
ImageIO and CoreGraphics.

**Fix** — Drop to 14.0 or 15.0 and confirm it still builds. Almost certainly an unintended default
from a toolchain upgrade.

### 13. There is no shared Xcode scheme

`Monarch-conversions.xcodeproj/xcshareddata/` — does not exist

The only scheme lives in `xcuserdata/orlandojesus.xcuserdatad/`. On a fresh clone or any CI runner,
`xcodebuild -scheme Monarch-conversions` fails outright. The 84 tests cannot run anywhere but this
laptop, which means the Strict TDD process has no enforcement point at all.

**Fix** — Xcode → Manage Schemes → tick *Shared*, and commit `xcshareddata/`. One checkbox, and the
prerequisite for everything else in this tier.

### 14. Spanish is fully translated and will never appear

`project.pbxproj` — `knownRegions = (en, Base)`

All three string catalogs are 100% translated — 16, 61 and 23 keys, every unit marked `translated`.
But `es` is missing from `knownRegions`, so no `es.lproj` is registered in the bundle and the
language switcher silently does nothing.

Separately, twelve strings use `String(localized:)`, which resolves against the bundle and ignores
the SwiftUI locale environment entirely. Even once the region is added, the whole top navigation
and the Settings sidebar stay in English.

**Fix** — Add `es` to `knownRegions`, then convert those twelve call sites to `Text(_:tableName:)`
so they honour the environment locale.

### 15. Nothing exists to produce a distributable build

No `.github/`, no `fastlane/`, no `Makefile`, no `ExportOptions.plist`, no scripts

No notarization step, no stapling, no DMG creation, no CI, no explicit Developer ID identity.
Hardened Runtime is correctly enabled, the sandbox entitlements are sane and the app icon is
complete at all ten sizes — the foundations are right. But every release would be a manual,
unreproducible sequence performed from memory.

**Fix** — After sharing the scheme: an `ExportOptions.plist` with `method = developer-id`, plus one
shell script chaining archive → export → `notarytool submit --wait` → `stapler staple` → DMG.

---

## Tier 4 — The process problem

This is the finding that matters most, because it is the one that let the other fifteen through.

### 16. The DNG feature has never been tested. Not once, on any machine.

`ImageConversionServiceTests.swift:87` · `ImageImportServiceTests.swift:164`

Both DNG tests open with the same two lines:

```swift
let path = "/Users/orlandojesus/Downloads/imagnes/IMG_2925 copia.DNG"
guard FileManager.default.fileExists(atPath: path) else { return }
```

That path does not exist — verified, including on the author's own machine. The folder is spelled
`imagnes`. So both tests return immediately and report green while executing nothing at all.

Release 0.24.0 shipped DNG and ProRAW support described as "verified via strict Red-Green-Refactor
TDD." It was verified by two tests that have never run a single assertion.

Two related signals point the same way:

- The `verify-report.md` for `import-outcome-tests` carries three identical SHA-256 values for
  `evidence_revision`, `test_output_hash` and `build_output_hash`. Three different artifacts cannot
  hash the same, so those fields were filled in rather than computed. Two other reports in the repo
  (`appearance-preference`, `language-preference`) carry three distinct hashes each, so the
  mechanism can do it correctly.
- The only real UI test, `BatchQueueStatusUITests`, fails on every run at
  `BatchQueueStatusUITests.swift:15` while the reports claim "All passed (Unit + UI)".

**Fix** — Commit a small DNG into `Fixtures/` alongside the ten fixtures already there, and make
every conditional guard call `Issue.record` instead of `return`. A test that cannot run must fail
loudly, never pass quietly.

---

## Verified working

This list matters. It is why the work above is a finishing job and not a rewrite.

- **The Release build is clean.** Zero errors, one benign AppIntents warning. It compiles for
  distribution today.
- **84 unit tests pass and most are real.** The import service, format model, filtering and
  formatting are genuinely covered, including all four rejection reasons and corrupt-file handling.
- **Drag and drop works in both directions.** Files drop into the dropzone, and results drag out to
  Finder, Figma and Slack from three separate views.
- **The empty state is genuinely good.** Icon, headline, explanation and a "Start Converting ⌘2"
  button that routes correctly.
- **Hardened Runtime and the sandbox are configured correctly.** Notarization prerequisites are
  already met.
- **The app icon is complete.** All ten macOS resolutions present at exactly the right pixel
  dimensions.
- **Both string catalogs are fully translated.** The Spanish work is done — it just is not reaching
  the bundle.
- **No telemetry, no third-party SDKs, no network entitlement.** The privacy claim in the About
  panel is true.
- **The architecture holds.** App → Scenes → Features → Core is respected, services are separated
  from views, and the domain models are properly typed.

---

## Order of work

Each step unblocks the next. Step one comes first because without it nothing fixed afterwards can
be proven.

| Step | Work | Why here |
|---|---|---|
| 1 | Share the scheme, fix the failing UI test | Until the suite runs off this laptop and every test is honest, nothing below can be verified. Foundation, not housekeeping. |
| 2 | The four data-loss defects (01–04) | Write the failing test first for each. The TDD discipline is real — it was just pointed at the safe parts. |
| 3 | SVG filter and comparison slider (05–06) | One expression and one parameter, and together they remove the two most visible "this app is broken" moments. |
| 4 | Crash, freeze, cancel, error messages (07–09) | The block that turns it from a demo into a tool people trust with fifty files. |
| 5 | Scroll, window sizing, state persistence (10–11) | Everything above must be right first, or this is polishing something that still loses data. |
| 6 | Deployment target, Spanish, notarization (12–15) | Last, because a distribution pipeline for a broken build just ships the break faster. |

---

## One thing to take from this

There are 84 passing tests, a clean Release build, twenty-one documented SDD changes and a real
architecture. That is more discipline than most solo projects ever get. But the discipline was
aimed at the parts that were already easy to verify — enums, formatters, value equality — while the
conversion engine's actual output format, the file-writing path and the destructive database
operations were left uncovered.

A test suite that cannot fail is not a safety net. It is a mirror. Point the same rigour at the
four items in Tier 1 and this becomes a launchable app in a week.
