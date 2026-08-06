import Foundation

public enum ImageFormat: String, Codable, CaseIterable, Sendable {
    case png = "PNG"
    case jpg = "JPG"
    case webp = "WebP"
    case avif = "AVIF"
    case svg = "SVG"
    case tif = "TIF"

    public init?(fileExtension: String) {
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
        default:
            return nil
        }
    }
}
