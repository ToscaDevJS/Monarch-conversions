import Foundation
import Testing
@testable import Monarch_conversions

@Suite struct ImageConversionServiceTests {
    private var fixturesURL: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("Fixtures")
    }

    private func fixtureURL(_ name: String) -> URL {
        fixturesURL.appendingPathComponent(name)
    }

    private var temporaryDirectoryURL: URL {
        FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    }

    @Test func convertsPngToJpgSuccessfully() async throws {
        let service = ImageConversionService()
        let sourceURL = fixtureURL("sample.png")
        let tempDir = temporaryDirectoryURL
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let settings = ConversionSettings(
            targetFormat: .jpg,
            quality: 0.8,
            outputDirectoryURL: tempDir
        )

        let result = try await service.convert(sourceURL: sourceURL, settings: settings)

        #expect(FileManager.default.fileExists(atPath: result.outputURL.path))
        #expect(result.outputSizeBytes > 0)
        #expect(result.outputDimensions.width == 400)
        #expect(result.outputDimensions.height == 300)
        #expect(result.durationSeconds >= 0.0)
    }

    @Test func convertsJpgToPngWithDimensionScaling() async throws {
        let service = ImageConversionService()
        let sourceURL = fixtureURL("sample.jpg")
        let tempDir = temporaryDirectoryURL
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let settings = ConversionSettings(
            targetFormat: .png,
            maxWidth: 200,
            maxHeight: 150,
            outputDirectoryURL: tempDir
        )

        let result = try await service.convert(sourceURL: sourceURL, settings: settings)

        #expect(FileManager.default.fileExists(atPath: result.outputURL.path))
        #expect(result.outputSizeBytes > 0)
        #expect(result.outputDimensions.width == 200)
        #expect(result.outputDimensions.height == 150)
    }

    @Test func rejectsUnsupportedTargetFormat() async throws {
        let service = ImageConversionService()
        let sourceURL = fixtureURL("sample.png")

        let settings = ConversionSettings(targetFormat: .svg)

        await #expect(throws: ConversionError.unsupportedTargetFormat(.svg)) {
            try await service.convert(sourceURL: sourceURL, settings: settings)
        }

        let dngSettings = ConversionSettings(targetFormat: .dng)
        await #expect(throws: ConversionError.unsupportedTargetFormat(.dng)) {
            try await service.convert(sourceURL: sourceURL, settings: dngSettings)
        }
    }

    @Test func convertsRealDngToJpgIfPresent() async throws {
        let path = "/Users/orlandojesus/Downloads/imagnes/IMG_2925 copia.DNG"
        guard FileManager.default.fileExists(atPath: path) else { return }
        let sourceURL = URL(fileURLWithPath: path)
        let service = ImageConversionService()
        let tempDir = temporaryDirectoryURL
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let settings = ConversionSettings(
            targetFormat: .jpg,
            quality: 0.85,
            outputDirectoryURL: tempDir
        )

        let result = try await service.convert(sourceURL: sourceURL, settings: settings)

        #expect(FileManager.default.fileExists(atPath: result.outputURL.path))
        #expect(result.outputSizeBytes > 0)
        #expect(result.outputDimensions.width == 3088)
        #expect(result.outputDimensions.height == 2316)
    }

    @Test func convertsWithWritableDirectoryWithoutFallback() async throws {
        let service = ImageConversionService()
        let sourceURL = fixtureURL("sample.png")
        let tempDir = temporaryDirectoryURL
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let settings = ConversionSettings(
            targetFormat: .jpg,
            quality: 0.8,
            outputDirectoryURL: tempDir
        )

        let result = try await service.convert(sourceURL: sourceURL, settings: settings)

        #expect(result.wasFallback == false)
        #expect(FileManager.default.fileExists(atPath: result.outputURL.path))
        #expect(result.outputURL.deletingLastPathComponent().path == tempDir.path)
    }

    @Test func convertsWithNonWritableDirectoryFallingBackToDownloads() async throws {
        let service = ImageConversionService()
        let sourceURL = fixtureURL("sample.png")
        // System directory is read-only in sandbox / SIP
        let readOnlyDir = URL(fileURLWithPath: "/System/Library")

        let settings = ConversionSettings(
            targetFormat: .jpg,
            quality: 0.8,
            outputDirectoryURL: readOnlyDir
        )

        let result = try await service.convert(sourceURL: sourceURL, settings: settings)

        #expect(result.wasFallback == true)
        #expect(FileManager.default.fileExists(atPath: result.outputURL.path))
        #expect(result.outputURL.deletingLastPathComponent().path == ImageConversionService.fallbackDirectory().path)

        // Clean up converted file from fallback directory
        try? FileManager.default.removeItem(at: result.outputURL)
    }

    @Test func batchQueueItemTracksFallbackState() {
        var item = BatchQueueItem(
            name: "test.png",
            format: .png,
            dimensions: PixelDimensions(width: 100, height: 100),
            originalSizeBytes: 1024
        )

        #expect(item.isFallbackDestination == false)
        item.isFallbackDestination = true
        #expect(item.isFallbackDestination == true)
    }

    @Test func generatesUniqueFilenameWhenOutputAlreadyExists() async throws {
        let service = ImageConversionService()
        let sourceURL = fixtureURL("sample.png")
        let tempDir = temporaryDirectoryURL
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let existingURL = tempDir.appendingPathComponent("sample_converted.jpg")
        let sentinelData = "SENTINEL_DO_NOT_OVERWRITE".data(using: .utf8)!
        try sentinelData.write(to: existingURL)

        let settings = ConversionSettings(
            targetFormat: .jpg,
            quality: 0.8,
            outputDirectoryURL: tempDir
        )

        let result = try await service.convert(sourceURL: sourceURL, settings: settings)

        #expect(result.outputURL.lastPathComponent == "sample_converted-1.jpg")
        #expect(FileManager.default.fileExists(atPath: result.outputURL.path))

        // Confirm original file was not overwritten
        let originalContent = try Data(contentsOf: existingURL)
        #expect(originalContent == sentinelData)
    }

    @Test func generatesSequentialUniqueFilenamesOnMultipleCollisions() async throws {
        let service = ImageConversionService()
        let sourceURL = fixtureURL("sample.png")
        let tempDir = temporaryDirectoryURL
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? FileManager.default.removeItem(at: tempDir)
        }

        let file0 = tempDir.appendingPathComponent("sample_converted.jpg")
        let file1 = tempDir.appendingPathComponent("sample_converted-1.jpg")
        try "0".data(using: .utf8)!.write(to: file0)
        try "1".data(using: .utf8)!.write(to: file1)

        let settings = ConversionSettings(
            targetFormat: .jpg,
            quality: 0.8,
            outputDirectoryURL: tempDir
        )

        let result = try await service.convert(sourceURL: sourceURL, settings: settings)

        #expect(result.outputURL.lastPathComponent == "sample_converted-2.jpg")
        #expect(FileManager.default.fileExists(atPath: result.outputURL.path))
    }
}
