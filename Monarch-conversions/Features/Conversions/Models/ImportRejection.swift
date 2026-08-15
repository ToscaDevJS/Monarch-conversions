import Foundation

public nonisolated struct ImportRejection: Identifiable, Equatable, Sendable {
    public enum Reason: Equatable, Sendable {
        case unsupportedType(fileExtension: String)
        case fileTooLarge(sizeBytes: Int64, limitBytes: Int64)
        case batchLimitExceeded(limit: Int)
        case unreadable
    }

    public let id: UUID
    public let fileName: String
    public let reason: Reason

    public nonisolated init(id: UUID = UUID(), fileName: String, reason: Reason) {
        self.id = id
        self.fileName = fileName
        self.reason = reason
    }
}
