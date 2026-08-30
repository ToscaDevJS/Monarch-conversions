# Orientation and Metadata Synchronization Specification

## Requirement
The image conversion engine MUST correctly synchronize pixel transformations with EXIF/TIFF metadata orientation tags, avoiding double rotations and ensuring metadata integrity across resize and format conversions.

## Scenarios

### Scenario 1: Resizing an Image with EXIF Orientation
- **Given** an input image with EXIF `Orientation = 6` (rotated 90° CW) and `preserveMetadata == true`
- **When** the image is resized using bounding box dimensions (`maxWidth`, `maxHeight`)
- **Then** the decoded pixel buffer MUST have the transform applied
- **And** the output image properties MUST normalize the `Orientation` tag (root and `{TIFF}`) to `1` (normal / top-left)
- **And** viewers SHALL display the image with the correct orientation without applying a duplicate 90° rotation.

### Scenario 2: Converting an Image Without Resizing
- **Given** an input image with EXIF `Orientation = 6` and `preserveMetadata == true`
- **When** the image is converted to another format without resizing (`maxWidth == nil`, `maxHeight == nil`)
- **Then** the pixel buffer MUST remain untransformed (original raw orientation)
- **And** the output metadata MUST retain the original `Orientation = 6` tag.

### Scenario 3: Converting with Metadata Removal
- **Given** an input image containing EXIF, GPS, and IPTC metadata
- **When** the conversion is performed with `preserveMetadata == false`
- **Then** the output image MUST NOT contain GPS, UserComment, or original EXIF tags.

### Scenario 4: Stripping Stale Embedded Thumbnails
- **Given** an input image containing an embedded thumbnail
- **When** the image is converted or resized
- **Then** the output image MUST strip source embedded thumbnail dictionaries to prevent thumbnail-pixel desynchronization.
