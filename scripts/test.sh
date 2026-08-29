#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Tests run signed so the App Sandbox and entitlements are active. Disabling code
# signing here would exercise an unsandboxed app and hide sandbox-only failures.
echo "==> Running Monarch Test Suite..."
xcodebuild test \
  -project "$PROJECT_ROOT/Monarch-conversions.xcodeproj" \
  -scheme "Monarch-conversions" \
  -destination "platform=macOS"

echo "==> All tests passed successfully!"
