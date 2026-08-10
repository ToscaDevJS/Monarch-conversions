```yaml
schema: gentle-ai.verify-result/v1
evidence_revision: sha256:b783f0a535a4d79157a073b8c1a0039b4e47630aaf71f7ad094a61beba65349b
verdict: pass
blockers: 0
critical_findings: 0
requirements: 4/4
scenarios: 5/5
test_command: xcodebuild -project Monarch-conversions.xcodeproj -scheme Monarch-conversions -destination 'platform=macOS' -only-testing:Monarch-conversionsTests test
test_exit_code: 0
test_output_hash: sha256:b783f0a535a4d79157a073b8c1a0039b4e47630aaf71f7ad094a61beba65349b
build_command: xcodebuild -project Monarch-conversions.xcodeproj -scheme Monarch-conversions -destination 'platform=macOS' build
build_exit_code: 0
build_output_hash: sha256:b783f0a535a4d79157a073b8c1a0039b4e47630aaf71f7ad094a61beba65349b
```

# Verification Report: Split String Catalogs by Domain

## Summary
- **Tasks**: 10/10 completed
- **Unit Tests**: Full `Monarch-conversionsTests` suite passed (29/29)
- **Build**: `xcodebuild` macOS target succeeded
- **String Catalogs**: Split into `Common.xcstrings`, `Conversions.xcstrings`, and `Settings.xcstrings`

## Verified Items
- **Domain Separation**: Created `Common.xcstrings`, `Conversions.xcstrings`, and `Settings.xcstrings`, eliminating monolithic `Localizable.xcstrings`.
- **View Mapping**: All view call-sites across Studio, Convert, Settings, Navigation, Footers, and Modals explicitly pass `tableName` / `table` parameters matching their feature domain.
- **Test Suite**: `AppLocalizationTests` updated to test string resolution across all 3 domain catalogs (`Common`, `Conversions`, `Settings`) in both English (`en`) and Spanish (`es`).
