import Foundation

public nonisolated enum ImportOutcome: Equatable, Sendable {
    case accepted(BatchQueueItem)
    case rejected(ImportRejection)
}
