# Tasks: Dashboard History Preservation & Shared Scheme

## Unit 1: Shared Scheme & TDD Suite
- [x] Create `Monarch-conversionsTests/DashboardHistoryPreservationTests.swift` validating record persistence.
- [x] Ensure `Monarch-conversions.xcodeproj/xcshareddata/xcschemes/Monarch-conversions.xcscheme` is committed and valid.

## Unit 2: Implementation
- [x] Remove `cleanLegacySeedsIfNeeded()` and `.onAppear` from `DashboardScene.swift`.

## Unit 3: Verification
- [x] Run test suite with `xcodebuild test` and confirm 100% pass rate.
- [x] Validate scheme list with `xcodebuild -list -project Monarch-conversions.xcodeproj`.
- [x] Produce `verify-report.md` and complete SDD verification.
