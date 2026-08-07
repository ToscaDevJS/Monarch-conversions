import Foundation

public enum ImportOutcome: Equatable, Sendable {
    case accepted(BatchQueueItem)
    case rejected(ImportRejection)
}
