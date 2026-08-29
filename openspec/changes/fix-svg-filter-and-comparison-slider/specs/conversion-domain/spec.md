# Delta for SVG Output Exclusion & Comparison Slider Real Output URL

## ADDED Requirements

### Requirement: SVG Output Format Exclusion

`ImageFormat.outputEligibleCases` MUST exclude `.svg` alongside `.webp`, `.jpegXL`, and `.dng`. Output format selection pickers MUST NEVER offer SVG as a target conversion format.

#### Scenario: outputEligibleCases excludes SVG
- **GIVEN** `ImageFormat.outputEligibleCases`
- **WHEN** evaluated
- **THEN** `.svg` is NOT contained in the collection
- **AND** only valid writable target formats (`.png`, `.jpg`, `.avif`, `.tif`, `.heic`, `.jpeg2000`) are included

### Requirement: Dual-URL Split Comparison Inspection

`SquooshInspectorView` MUST accept distinct URLs for the original source image (`imageURL` / `originalImageURL`) and the converted result (`outputImageURL`). The left split view pane MUST render the original image, and the right split view pane MUST render the converted output image (or appropriate placeholder when not yet converted).

#### Scenario: Inspector receives both source and output URLs
- **GIVEN** a source image URL and a converted output image URL
- **WHEN** passed into `SquooshInspectorView`
- **THEN** the left side loads the source URL and the right side loads the output URL
