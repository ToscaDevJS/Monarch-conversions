# Proposal: Real-Time Batch Queue Item Status Indicators

## Problem
In `BatchQueueView`, items in the batch conversion queue do not show individual conversion status progress. Users cannot see which image is currently being processed or which items have completed.

## Proposed Solution
1. **Status Enum**: Add `BatchItemStatus` (`.queued`, `.converting`, `.done`, `.failed`) to `BatchQueueItem`.
2. **Batch Pipeline Tracking**: Update `ConvertScene.processBatchConversion()` to set `.converting` before converting an item, and `.done` upon completion.
3. **Visual Badges**: Update `BatchQueueItemRow.swift` to render live progress spinner when `.converting` and a green checkmark badge (`✓ Done`) when `.done`.
4. **Unit Tests**: Create `BatchQueueItemStatusTests.swift` validating status transitions.

## Impact
Gives users real-time feedback during batch conversions.
