# Tasks: Fix Deployment Target, Enable Spanish Localization in Project & Add CI Scripts

## Unit 1: Strict TDD Test Suite (RED)
- [x] Create `Monarch-conversionsTests/ProjectConfigurationTests.swift`.
- [x] Run `xcodebuild test` and verify RED phase failure.

## Unit 2: Implementation (GREEN)
- [x] Update `project.pbxproj` with `MACOSX_DEPLOYMENT_TARGET = 14.0;`.
- [x] Add `es` to `knownRegions` in `project.pbxproj`.
- [x] Create executable `scripts/build.sh`, `scripts/test.sh`, and `scripts/archive.sh`.
- [x] Run `xcodebuild test` and verify GREEN phase pass.

## Unit 3: Verification & SDD
- [x] Run test suite with `scripts/test.sh`.
- [x] Produce `verify-report.md` and complete SDD verification.
