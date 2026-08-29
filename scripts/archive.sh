#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ARCHIVE_PATH="${1:-$PROJECT_ROOT/build/Monarch-conversions.xcarchive}"

mkdir -p "$(dirname "$ARCHIVE_PATH")"

# The archive must be signed: an unsigned archive cannot be exported for
# Developer ID distribution or submitted to notarytool.
echo "==> Creating Release Archive at $ARCHIVE_PATH..."
xcodebuild archive \
  -project "$PROJECT_ROOT/Monarch-conversions.xcodeproj" \
  -scheme "Monarch-conversions" \
  -destination "generic/platform=macOS" \
  -archivePath "$ARCHIVE_PATH"

echo "==> Archive created successfully at: $ARCHIVE_PATH"
