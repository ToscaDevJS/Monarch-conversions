# File Import Capability Spec

## Purpose

Importing real image files into the Convert queue via drag-and-drop and Browse, converging on one pipeline that validates, extracts metadata, and produces typed `BatchQueueItem`s.

## Requirements

### Requirement: Supported Import File Types

The import pipeline MUST accept png, jpg/jpeg, webp, avif, tif/tiff, heic, jpeg2000, and jpegXL files, and MUST reject all other types, including svg.

#### Scenario: Mixed supported and unsupported files
- GIVEN a heic file and an svg file
- WHEN both are passed to the import pipeline
- THEN the heic file enqueues as format `.heic` and the svg file is rejected with a reason

### Requirement: Unified Import Pipeline (Drop and Browse)

Drag-and-drop onto `BatchDropzoneView` and the "Browse files" button (opening `NSOpenPanel`, scoped to allowed types — fixing the previously dead `onBrowse` wiring) MUST both resolve to the same `[URL] → [BatchQueueItem]` pipeline.

#### Scenario: Drop and Browse are equivalent
- GIVEN one supported file URL
- WHEN it is imported via drop and separately via Browse
- THEN both produce a `BatchQueueItem` with identical name, format, dimensions, and byte size

### Requirement: ImageIO Metadata Extraction

For each accepted file, the pipeline MUST extract format, pixel width/height, and byte size using ImageIO, without decoding full pixel data.

#### Scenario: Metadata matches the file
- GIVEN a valid 400×300 PNG fixture of N bytes on disk
- WHEN it is imported
- THEN the item reports format `.png`, dimensions 400×300, and `originalSizeBytes == N`

### Requirement: Batch and Per-File Limits

The pipeline MUST accept at most 50 files per import operation and MUST reject any file over 100 MB, independent of other files in the batch. Files within both limits MUST still be enqueued.

#### Scenario: Over both limits
- GIVEN 55 files offered together, one of which is 150 MB
- WHEN they are imported
- THEN the oversized file and files 51–55 are rejected; the rest are enqueued

### Requirement: Per-File Failure Isolation

A file that is unreadable, corrupt, or fails metadata extraction MUST be skipped without aborting the rest of the batch import.

#### Scenario: Corrupt file among valid files
- GIVEN a batch of 3 valid files and 1 corrupt file
- WHEN the batch is imported
- THEN the 3 valid files are enqueued and the corrupt file is rejected with an explanation

### Requirement: Visible Rejection Feedback

Every rejected file (oversized, over batch limit, unsupported type, or unreadable) MUST produce a visible, per-file explanation naming the file and reason. The presentation surface (toast vs. inline row) is a design-time decision; feedback MUST NOT be silently dropped.

#### Scenario: Every rejection is explained
- GIVEN a batch with one oversized, one unsupported-type, and one corrupt file
- WHEN the import completes
- THEN three distinct visible rejection explanations are produced, one per file

### Requirement: Empty Queue on First Launch

The Convert queue MUST start empty on first launch, with no hardcoded `BatchQueueItem`s. The dropzone MUST be visible whenever the queue is empty.

#### Scenario: First launch shows empty queue
- GIVEN a freshly launched app with no prior imports
- WHEN `ConvertScene` appears
- THEN the batch queue contains zero items and the dropzone is visible
