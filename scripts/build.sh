#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Build signed so the entitlements and App Sandbox match what ships.
echo "==> Building Monarch (Debug)..."
xcodebuild build \
  -project "$PROJECT_ROOT/Monarch-conversions.xcodeproj" \
  -scheme "Monarch-conversions" \
  -destination "platform=macOS"

echo "==> Build successful!"
