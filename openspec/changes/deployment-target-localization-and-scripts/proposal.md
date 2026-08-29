# Proposal: Fix Deployment Target, Enable Spanish Localization in Project & Add CI Scripts

## Intent

As identified in `LAUNCH-TRIAGE.md` (Defect 12, Defect 14 & Defect 15):
1. **Defect 12 (macOS Deployment Target Typo)**: `MACOSX_DEPLOYMENT_TARGET` was set to `26.5` in `project.pbxproj`. It must be set to `14.0` (Sonoma), the minimum supported version for SwiftData and modern SwiftUI features used in the app.
2. **Defect 14 (Spanish Localization Missing in `knownRegions`)**: The project contains comprehensive Spanish `.xcstrings` Catalogs, but `knownRegions` only listed `(en, Base)`. Adding `es` enables Xcode to bundle and export Spanish strings properly.
3. **Defect 15 (Missing Build & Test Scripts)**: Provide standard distribution, headless test, and release archiving scripts in `scripts/`.

## Scope

### In Scope
- Update `MACOSX_DEPLOYMENT_TARGET` to `14.0` across all configurations in `project.pbxproj`.
- Add `es` to `knownRegions` in `project.pbxproj`.
- Add executable shell scripts:
  - `scripts/build.sh`
  - `scripts/test.sh`
  - `scripts/archive.sh`
- Strict TDD: Unit test verifying deployment target metadata and script executability.

### Out of Scope
- Hardcoded App Store Connect API credentials (scripts accept environment variables).

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added requirements for valid macOS 14.0 deployment target, Spanish localization inclusion, and automated release scripts.

## Approach

1. **RED Phase**:
   - Write tests in `Monarch-conversionsTests/ProjectConfigurationTests.swift` verifying deployment target version consistency and script existence.
   - Run `xcodebuild test` to observe failure.
2. **GREEN Phase**:
   - Update `project.pbxproj` (`MACOSX_DEPLOYMENT_TARGET = 14.0;`, `knownRegions` includes `es`).
   - Create `scripts/build.sh`, `scripts/test.sh`, and `scripts/archive.sh`.
   - Run `xcodebuild test` to observe pass.
3. **REFACTOR Phase**:
   - Verify build and tests with `scripts/test.sh` and complete SDD verification.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions.xcodeproj/project.pbxproj` | Modified | Set `14.0` target and add `es` to `knownRegions` |
| `scripts/build.sh` | New | Build script for Monarch app |
| `scripts/test.sh` | New | Automated test runner script |
| `scripts/archive.sh` | New | Xcode archive creation script |
| `Monarch-conversionsTests/ProjectConfigurationTests.swift` | New | Unit tests for configuration sanity |
| `openspec/changes/deployment-target-localization-and-scripts/` | New | SDD specifications and verification report |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| pbxproj merge conflict | Low | Edit exact lines using line-targeted replacements |

## Success Criteria

- [ ] All targets have `MACOSX_DEPLOYMENT_TARGET = 14.0`.
- [ ] `knownRegions` includes `es`.
- [ ] `scripts/test.sh` runs cleanly and exits with code 0.
- [ ] 100% tests pass in `xcodebuild test`.
