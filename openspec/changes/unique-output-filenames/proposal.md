# Proposal: Unique Output Filenames on Collision

## Intent

As identified in `LAUNCH-TRIAGE.md` (Defect 02), `ImageConversionService` unconditionally writes converted images to `{fileBaseName}_converted.{ext}` without checking if a file with that name already exists. When converting multiple files sharing the same base name (e.g. `logo.png` and `logo.jpg` into PNG) or re-running conversions in an existing directory, previous conversion outputs and user files are silently overwritten and lost.

## Scope

### In Scope
- Implement collision-free unique filename generation (`uniqueDestinationURL`) in `ImageConversionService.swift`.
- When `{baseName}_converted.{ext}` exists on disk, append numeric suffixes `-1`, `-2`, `-3`, etc.
- Apply unique filename resolution to both primary destination paths and sandbox fallback paths.
- Strict TDD: Unit tests in `ImageConversionServiceTests.swift` validating single and sequential collisions.

### Out of Scope
- Prompting for user rename (the design pattern across native macOS converters is automatic collision-avoidance suffixes).

## Capabilities

### Modified Capabilities
- `conversion-domain`: Added requirement that image conversions never overwrite existing destination files and automatically append unique collision suffixes.

## Approach

1. Strict TDD: Add unit tests in `ImageConversionServiceTests.swift` asserting that converting an image into a directory with an existing `{base}_converted.{ext}` outputs `{base}_converted-1.{ext}`, and with `-1` present outputs `{base}_converted-2.{ext}`.
2. Implement `uniqueDestinationURL(in:baseName:ext:)` in `ImageConversionService.swift`.
3. Verify test passes via `xcodebuild test` and validate 0 regressions.

## Affected Areas

| Area | Impact | Description |
|---|---|---|
| `Monarch-conversions/Features/Conversions/Services/ImageConversionService.swift` | Modified | Added unique output URL resolution before destination creation |
| `Monarch-conversionsTests/ImageConversionServiceTests.swift` | Modified | Added unit tests for collision detection and suffix incrementing |
| `openspec/changes/unique-output-filenames/` | New | SDD specifications and verification report |

## Risks

| Risk | Likelihood | Mitigation |
|---|---|---|
| Loop hanging on file systems with race conditions | Low | Deterministic integer increment loop checking `FileManager.fileExists` |

## Success Criteria

- [ ] Existing files on disk are never overwritten during conversion.
- [ ] Output URLs receive clean `-1`, `-2`, etc. suffixes on collision.
- [ ] All unit and UI tests pass with 0 regressions.
