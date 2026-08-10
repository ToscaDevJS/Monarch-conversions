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
    }
}
