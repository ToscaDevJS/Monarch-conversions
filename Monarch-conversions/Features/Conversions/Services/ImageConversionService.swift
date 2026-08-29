import Foundation
import ImageIO
import UniformTypeIdentifiers
import CoreGraphics

public nonisolated enum ConversionError: Error, LocalizedError, Equatable {
    case missingSourceURL
    case unreadableSource
    case unsupportedTargetFormat(ImageFormat)
    case destinationCreationFailed
    case conversionFailed
    case outputFileNotFound

    public var errorDescription: String? {
        switch self {
        case .missingSourceURL:
            return "The image source URL is missing."
        case .unreadableSource:
            return "The source image file could not be read."
        case .unsupportedTargetFormat(let format):
            return "Target format \(format.rawValue) is not supported for encoding."
        case .destinationCreationFailed:
            return "Failed to create destination image file."
        case .conversionFailed:
            return "Image conversion process failed."
        case .outputFileNotFound:
            return "Converted output file was not found on disk."
        }
    }
}

public nonisolated struct ImageConversionResult: Sendable, Equatable {
    public let outputURL: URL
    public let outputSizeBytes: Int64
    public let outputDimensions: PixelDimensions
    public let durationSeconds: Double
    public let wasFallback: Bool

    public init(
        outputURL: URL,
        outputSizeBytes: Int64,
        outputDimensions: PixelDimensions,
        durationSeconds: Double,
        wasFallback: Bool = false
    ) {
        self.outputURL = outputURL
        self.outputSizeBytes = outputSizeBytes
        self.outputDimensions = outputDimensions
        self.durationSeconds = durationSeconds
        self.wasFallback = wasFallback
    }
}

public nonisolated struct ImageConversionService: Sendable {

    public init() {}

    public static func uti(for format: ImageFormat) -> UTType? {
        switch format {
        case .png:
            return .png
        case .jpg:
            return .jpeg
        case .webp:
            return UTType("org.webmproject.webp") ?? UTType("public.webp")
        case .avif:
            return UTType("public.avif") ?? UTType("org.aomedia.avif")
        case .heic:
            return .heic
        case .tif:
            return .tiff
        case .jpeg2000:
            return UTType("public.jpeg-2000") ?? UTType("public.jp2")
        case .svg, .jpegXL, .dng:
            return nil
        }
    }

    public static func fallbackDirectory() -> URL {
        if let downloads = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first,
           FileManager.default.isWritableFile(atPath: downloads.path) {
            return downloads
        }
        return FileManager.default.temporaryDirectory
    }

    public static func uniqueDestinationURL(in directory: URL, baseName: String, ext: String) -> URL {
        let initialURL = directory.appendingPathComponent("\(baseName)_converted.\(ext)")
        guard FileManager.default.fileExists(atPath: initialURL.path) else {
            return initialURL
        }

        var counter = 1
        while true {
            let candidateURL = directory.appendingPathComponent("\(baseName)_converted-\(counter).\(ext)")
            if !FileManager.default.fileExists(atPath: candidateURL.path) {
                return candidateURL
            }
            counter += 1
        }
    }

    public func convert(
        sourceURL: URL,
        settings: ConversionSettings
    ) async throws -> ImageConversionResult {
        let startTime = Date()

        guard let targetUTI = Self.uti(for: settings.targetFormat) else {
            throw ConversionError.unsupportedTargetFormat(settings.targetFormat)
        }

        let hasSecurityAccess = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if hasSecurityAccess {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        let chosenOutputDirectory = settings.outputDirectoryURL
        let hasOutputSecurityAccess = chosenOutputDirectory?.startAccessingSecurityScopedResource() ?? false
        defer {
            if hasOutputSecurityAccess {
                chosenOutputDirectory?.stopAccessingSecurityScopedResource()
            }
        }

        let sourceOptions = [kCGImageSourceShouldCache as String: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(sourceURL as CFURL, sourceOptions) else {
            throw ConversionError.unreadableSource
        }

        // Determine target output URL and check directory write permissions
        let candidateDirectory = chosenOutputDirectory ?? sourceURL.deletingLastPathComponent()
        let fileBaseName = sourceURL.deletingPathExtension().lastPathComponent
        let ext = settings.targetFormat == .jpg ? "jpg" : settings.targetFormat.rawValue.lowercased()

        let isDirectoryWritable = FileManager.default.isWritableFile(atPath: candidateDirectory.path)
        let resolvedDirectory: URL
        let initialWasFallback: Bool

        if isDirectoryWritable {
            resolvedDirectory = candidateDirectory
            initialWasFallback = false
        } else {
            resolvedDirectory = Self.fallbackDirectory()
            initialWasFallback = true
        }

        var destinationURL = Self.uniqueDestinationURL(in: resolvedDirectory, baseName: fileBaseName, ext: ext)
        var wasFallback = initialWasFallback

        // Prepare destination
        var destination = CGImageDestinationCreateWithURL(
            destinationURL as CFURL,
            targetUTI.identifier as CFString,
            1,
            nil
        )

        if destination == nil {
            let fallbackDir = Self.fallbackDirectory()
            let fallbackURL = Self.uniqueDestinationURL(in: fallbackDir, baseName: fileBaseName, ext: ext)
            if let fallbackDestination = CGImageDestinationCreateWithURL(
                fallbackURL as CFURL,
                targetUTI.identifier as CFString,
                1,
                nil
            ) {
                destination = fallbackDestination
                destinationURL = fallbackURL
                wasFallback = true
            } else {
                let tempURL = Self.uniqueDestinationURL(in: FileManager.default.temporaryDirectory, baseName: fileBaseName, ext: ext)
                if let tempDestination = CGImageDestinationCreateWithURL(
                    tempURL as CFURL,
                    targetUTI.identifier as CFString,
                    1,
                    nil
                ) {
                    destination = tempDestination
                    destinationURL = tempURL
                    wasFallback = true
                }
            }
        }

        guard let validDestination = destination else {
            throw ConversionError.destinationCreationFailed
        }

        // Processing options
        var destinationProperties: [CFString: Any] = [:]

        // Compression quality
        destinationProperties[kCGImageDestinationLossyCompressionQuality] = settings.quality as CFNumber

        // Optional metadata copying
        if settings.preserveMetadata, let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] {
            // Keep existing metadata except width/height overrides
            for (key, val) in metadata {
                if key != kCGImagePropertyPixelWidth && key != kCGImagePropertyPixelHeight {
                    destinationProperties[key] = val
                }
            }
        }

        // Image resizing if maximum dimensions requested
        let cgImage: CGImage?
        if let maxW = settings.maxWidth, let maxH = settings.maxHeight, maxW > 0, maxH > 0 {
            let maxPixelSize = max(maxW, maxH)
            let thumbnailOptions: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
                kCGImageSourceCreateThumbnailWithTransform: true
            ]
            cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary)
        } else {
            cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        }

        guard let finalCGImage = cgImage else {
            throw ConversionError.conversionFailed
        }

        CGImageDestinationAddImage(validDestination, finalCGImage, destinationProperties as CFDictionary)

        guard CGImageDestinationFinalize(validDestination) else {
            throw ConversionError.conversionFailed
        }

        let outputSizeBytes = (try? destinationURL.resourceValues(forKeys: [.fileSizeKey]).fileSize).map(Int64.init) ?? 0
        let outputDimensions = PixelDimensions(width: finalCGImage.width, height: finalCGImage.height)
        let duration = Date().timeIntervalSince(startTime)

        return ImageConversionResult(
            outputURL: destinationURL,
            outputSizeBytes: outputSizeBytes,
            outputDimensions: outputDimensions,
            durationSeconds: duration,
            wasFallback: wasFallback
        )
    }
}
