import Foundation
import ImageIO
import UniformTypeIdentifiers

public struct ImageImportService: Sendable {
    public var maxFileSizeBytes: Int64
    public var maxBatchCount: Int

    public init(
        maxFileSizeBytes: Int64 = 100 * 1024 * 1024, // 100 MB
        maxBatchCount: Int = 50
    ) {
        self.maxFileSizeBytes = maxFileSizeBytes
        self.maxBatchCount = maxBatchCount
    }

    public static var allowedContentTypes: [UTType] {
        let extensions = ["png", "jpg", "jpeg", "webp", "avif", "tif", "tiff", "heic", "heif", "jp2", "j2k", "jpf", "jxl"]
        return extensions.compactMap { UTType(filenameExtension: $0) }
    }

    public nonisolated func importFiles(at urls: [URL], existingCount: Int) async -> [ImportOutcome] {
        var outcomes: [ImportOutcome] = []
        var acceptedCount = 0

        for url in urls {
            let ext = url.pathExtension.lowercased()
            guard let format = ImageFormat(fileExtension: ext), format != .svg else {
                outcomes.append(.rejected(ImportRejection(
                    fileName: url.lastPathComponent,
                    reason: .unsupportedType(fileExtension: ext.isEmpty ? "unknown" : ext)
                )))
                continue
            }

            let sizeBytes = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize).map(Int64.init) ?? 0
            if sizeBytes > maxFileSizeBytes {
                outcomes.append(.rejected(ImportRejection(
                    fileName: url.lastPathComponent,
                    reason: .fileTooLarge(sizeBytes: sizeBytes, limitBytes: maxFileSizeBytes)
                )))
                continue
            }

            let hasAccess = url.startAccessingSecurityScopedResource()
            let source: CGImageSource? = {
                let options = [kCGImageSourceShouldCache as String: false] as CFDictionary
                return CGImageSourceCreateWithURL(url as CFURL, options)
            }()

            var dimensions: PixelDimensions? = nil
            if let source = source, let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] {
                let width = (properties[kCGImagePropertyPixelWidth] as? NSNumber)?.intValue ?? 0
                let height = (properties[kCGImagePropertyPixelHeight] as? NSNumber)?.intValue ?? 0
                if width > 0 && height > 0 {
                    dimensions = PixelDimensions(width: width, height: height)
                }
            }

            if hasAccess {
                url.stopAccessingSecurityScopedResource()
            }

            guard let validDimensions = dimensions else {
                outcomes.append(.rejected(ImportRejection(
                    fileName: url.lastPathComponent,
                    reason: .unreadable
                )))
                continue
            }

            if existingCount + acceptedCount >= maxBatchCount {
                outcomes.append(.rejected(ImportRejection(
                    fileName: url.lastPathComponent,
                    reason: .batchLimitExceeded(limit: maxBatchCount)
                )))
                continue
            }

            acceptedCount += 1
            let item = BatchQueueItem(
                name: url.lastPathComponent,
                format: format,
                dimensions: validDimensions,
                originalSizeBytes: sizeBytes,
                targetFormat: nil,
                targetSizeBytes: nil
            )
            outcomes.append(.accepted(item))
        }

        return outcomes
    }
}
