# Proposal: Preserve Dashboard History & Shared Xcode Scheme

## Intent

As identified in `LAUNCH-TRIAGE.md` (Defect 01 & Defect 13):
1. `DashboardScene.swift` contained a legacy cleanup routine (`cleanLegacySeedsIfNeeded()`) invoked on `.onAppear` that deleted user conversion records if their filename matched ordinary names (such as `team-photo.png`, `hero-banner.png`, `product-shot.jpg`) or if their project matched `"Marketing"`, `"Storefront"`, `"Brand"`, or `"Events"`. This caused silent data loss of legitimate conversion history.
2. The project lacked a committed shared Xcode scheme in `Monarch-conversions.xcodeproj/xcshareddata/xcschemes/`, preventing CI pipelines and other developer checkouts from building and testing the project.

## Scope

### In Scope
- Remove `cleanLegacySeedsIfNeeded()` and its `.onAppear` trigger from `Scenes/Dashboard/DashboardScene.swift`.
- Add dedicated unit tests verifying that records with marketing/brand projects and standard image filenames are preserved and never purged.
- Commit shared Xcode scheme `Monarch-conversions.xcscheme` in `Monarch-conversions.xcodeproj/xcshareddata/xcschemes/`.

### Out of Scope
- Modifying other Tier 1 data-loss items (output filename collision, store fallback, duplicate batch insertion) which will be addressed in subsequent dedicated SDD cycles.

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added explicit guarantee that user conversion history is durable and not subject to hardcoded filename/project purges on scene appearance.

## Approach

1. Strict TDD: Author test in `Monarch-conversionsTests/DashboardHistoryPreservationTests.swift` validating that `ConversionRecord` instances with previously targeted names and projects persist in the model context.
2. Remove `cleanLegacySeedsIfNeeded()` and the `.onAppear` invocation from `DashboardScene.swift`.
3. Provide shared Xcode scheme `Monarch-conversions.xcscheme` under `xcshareddata/xcschemes/`.
4. Validate entire test suite passes cleanly via `xcodebuild test` and complete SDD verification.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions/Scenes/Dashboard/DashboardScene.swift` | Modified | Removed destructive `cleanLegacySeedsIfNeeded()` |
| `Monarch-conversions.xcodeproj/xcshareddata/xcschemes/Monarch-conversions.xcscheme` | New | Shared Xcode scheme for CLI & CI builds |
| `Monarch-conversionsTests/DashboardHistoryPreservationTests.swift` | New | Swift Testing unit tests verifying record preservation |
| `openspec/changes/preserve-dashboard-history/` | New | SDD specifications and verification report |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Old mock data lingering in dev environments | Low | Mock seeds were already removed in 0.16.0; SwiftData stores are created cleanly |

## Success Criteria

- [ ] `DashboardScene` does not delete any user records on appearance.
- [ ] Unit tests verify persistence of records with arbitrary names and projects.
- [ ] `xcodebuild -list -project Monarch-conversions.xcodeproj` lists `Monarch-conversions` scheme under shared schemes.
- [ ] All unit and UI tests pass with 0 regressions.
