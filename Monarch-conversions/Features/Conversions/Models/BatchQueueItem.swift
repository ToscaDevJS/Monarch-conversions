import Foundation

public struct BatchQueueItem: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let name: String
    public let format: ImageFormat
    public let dimensions: PixelDimensions
    public let originalSizeBytes: Int64
    public let targetFormat: ImageFormat?
    public let targetSizeBytes: Int64?
    public let fileURL: URL?

    public var reductionPercent: Int? {
        guard let target = targetSizeBytes else { return nil }
        guard originalSizeBytes > 0 else { return 0 }
        let diff = Double(target - originalSizeBytes)
        let pct = (diff / Double(originalSizeBytes)) * 100.0
        return Int(round(pct))
    }

    public init(
        id: UUID = UUID(),
        name: String,
        format: ImageFormat,
        dimensions: PixelDimensions,
        originalSizeBytes: Int64,
        targetFormat: ImageFormat? = nil,
        targetSizeBytes: Int64? = nil,
        fileURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.format = format
        self.dimensions = dimensions
        self.originalSizeBytes = originalSizeBytes
        self.targetFormat = targetFormat
        self.targetSizeBytes = targetSizeBytes
        self.fileURL = fileURL
    }
}
