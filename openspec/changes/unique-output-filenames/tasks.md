# Tasks: Unique Output Filenames on Collision

## Unit 1: Strict TDD Test Suite
- [x] Add unit test `generatesUniqueFilenameWhenOutputAlreadyExists` in `ImageConversionServiceTests.swift`.
- [x] Add unit test for multiple sequential collisions (`-1`, `-2`) in `ImageConversionServiceTests.swift`.

## Unit 2: Implementation
- [x] Implement `uniqueDestinationURL` helper in `ImageConversionService.swift`.
- [x] Update primary and fallback destination URL resolution in `ImageConversionService.swift`.

## Unit 3: Verification
- [x] Run full test suite with `xcodebuild test` and confirm 100% pass rate.
- [x] Produce `verify-report.md` and validate SDD compliance with `gentle-ai`.
