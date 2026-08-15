import Foundation

public nonisolated struct ConversionSettings: Equatable, Sendable {
    public var targetFormat: ImageFormat
    public var quality: Double // 0.0 to 1.0
    public var maxWidth: Int?
    public var maxHeight: Int?
    public var preserveMetadata: Bool
    public var outputDirectoryURL: URL?

    public init(
        targetFormat: ImageFormat = .png,
        quality: Double = 0.85,
        maxWidth: Int? = nil,
        maxHeight: Int? = nil,
        preserveMetadata: Bool = true,
        outputDirectoryURL: URL? = nil
    ) {
        self.targetFormat = targetFormat
        self.quality = quality
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.preserveMetadata = preserveMetadata
        self.outputDirectoryURL = outputDirectoryURL
    }
}
