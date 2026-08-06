import Foundation

public enum ConversionFormatting {
    public static func byteSize(_ bytes: Int64) -> String {
        if bytes < 1_000_000 {
            let kb = Int(round(Double(bytes) / 1_000.0))
            return "\(kb) KB"
        } else {
            let mb = Double(bytes) / 1_000_000.0
            return String(format: "%.1f MB", mb)
        }
    }

    public static func dimensions(_ d: PixelDimensions) -> String {
        return "\(d.width) × \(d.height)"
    }

    public static func reduction(percent: Int) -> String {
        return "\(percent)%"
    }
}
