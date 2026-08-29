import Foundation

public struct BatchQueueProcessor {
    public static func pendingItems(in items: [BatchQueueItem]) -> [BatchQueueItem] {
        items.filter { $0.status == .queued }
    }

    public static func shouldProcess(item: BatchQueueItem) -> Bool {
        item.status == .queued
    }
}
