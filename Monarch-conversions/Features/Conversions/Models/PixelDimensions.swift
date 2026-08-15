import Foundation

public nonisolated struct PixelDimensions: Equatable, Codable, Sendable {
    public let width: Int
    public let height: Int

    public nonisolated init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}
