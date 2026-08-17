import Foundation

public nonisolated enum ConversionFormatting {
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

    public static func shortFileId(_ fileId: String) -> String {
        let trimmed = fileId.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count > 8 {
            return String(trimmed.prefix(8)).uppercased()
        }
        return trimmed.uppercased()
    }

    public static func reduction(percent: Int) -> String {
        return "\(percent)%"
    }

    public static func rejectionMessage(_ reason: ImportRejection.Reason) -> String {
        switch reason {
        case .unsupportedType(let ext):
            return "Unsupported format (.\(ext))"
        case .fileTooLarge(let sizeBytes, let limitBytes):
            let limitFormatted = byteSize(limitBytes)
            let sizeFormatted = byteSize(sizeBytes)
            return "File exceeds \(limitFormatted) limit (\(sizeFormatted))"
        case .batchLimitExceeded(let limit):
            return "Batch limit of \(limit) files reached"
        case .unreadable:
            return "File could not be read or decoded"
        }
    }
}

