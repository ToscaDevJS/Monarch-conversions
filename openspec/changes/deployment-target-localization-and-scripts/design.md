# Design: Fix Deployment Target, Enable Spanish Localization in Project & Add CI Scripts

## Architecture & Configuration Changes

### 1. `project.pbxproj` Updates

1. `knownRegions`:
   ```pbxproj
   knownRegions = (
       en,
       Base,
       es,
   );
   ```
2. Replace all instances of `MACOSX_DEPLOYMENT_TARGET = 26.5;` with `MACOSX_DEPLOYMENT_TARGET = 14.0;`.

### 2. CI & Release Scripts

- `scripts/build.sh`:
  ```bash
  #!/usr/bin/env bash
  set -euo pipefail
  xcodebuild build -project Monarch-conversions.xcodeproj -scheme Monarch-conversions -destination 'platform=macOS' CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
  ```
- `scripts/test.sh`:
  ```bash
  #!/usr/bin/env bash
  set -euo pipefail
  xcodebuild test -project Monarch-conversions.xcodeproj -scheme Monarch-conversions -destination 'platform=macOS' CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
  ```
- `scripts/archive.sh`:
  ```bash
  #!/usr/bin/env bash
  set -euo pipefail
  ARCHIVE_PATH="${1:-build/Monarch-conversions.xcarchive}"
  mkdir -p "$(dirname "$ARCHIVE_PATH")"
  xcodebuild archive -project Monarch-conversions.xcodeproj -scheme Monarch-conversions -destination 'generic/platform=macOS' -archivePath "$ARCHIVE_PATH" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
  echo "Archive created at $ARCHIVE_PATH"
  ```
