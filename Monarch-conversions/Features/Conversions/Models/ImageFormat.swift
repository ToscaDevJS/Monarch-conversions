import Foundation

public nonisolated enum ImageFormat: String, Codable, CaseIterable, Sendable {
    case png = "PNG"
    case jpg = "JPG"
    /// Decode-only: WebP can be imported but MUST NOT be offered as a conversion output (target) format.
    case webp = "WebP"
    case avif = "AVIF"
    case svg = "SVG"
    case tif = "TIF"
    case heic = "HEIC"
    case jpeg2000 = "JP2"
    /// Decode-only, like `webp`: JPEG XL can be imported but MUST NOT be offered as a conversion output (target) format.
    case jpegXL = "JXL"
    /// Decode-only: DNG (Digital Negative / RAW) can be imported but MUST NOT be offered as a conversion output format.
    case dng = "DNG"

    /// Formats eligible to appear in a conversion output (target) picker.
    /// Excludes decode-only/import-only formats (`webp`, `jpegXL`, `dng`) so future `allCases`-driven
    /// output pickers never accidentally offer them.
    public nonisolated static var outputEligibleCases: [ImageFormat] {
        allCases.filter { $0 != .webp && $0 != .jpegXL && $0 != .dng }
    }

    public nonisolated init?(fileExtension: String) {
        let normalized = fileExtension.lowercased()
        switch normalized {
        case "png":
            self = .png
        case "jpg", "jpeg":
            self = .jpg
        case "webp":
            self = .webp
        case "avif":
            self = .avif
        case "svg":
            self = .svg
        case "tif", "tiff":
            self = .tif
        case "heic", "heif":
            self = .heic
        case "jp2", "j2k", "jpf":
            self = .jpeg2000
        case "jxl":
            self = .jpegXL
        case "dng":
            self = .dng
        default:
            return nil
        }
    }
}
