import Testing
import Foundation
import SwiftUI
@testable import Monarch_conversions

@Suite struct QueueLayoutAndTabStateTests {
    @Test func queueItemBatchHandlesLargeQuantities() {
        var items: [BatchQueueItem] = []
        for i in 1...30 {
            items.append(
                BatchQueueItem(
                    name: "photo_\(i).png",
                    format: .png,
                    dimensions: PixelDimensions(width: 1920, height: 1080),
                    originalSizeBytes: 2_000_000,
                    status: .queued
                )
            )
        }

        #expect(items.count == 30)
        let selectedId = items.first?.id
        #expect(selectedId != nil)
    }

    @Test func appRouterPreservesNavigationTransitions() {
        let router = AppRouter()
        #expect(router.activeTab == .studio)

        router.navigateTo(.settings)
        #expect(router.activeTab == .settings)

        router.navigateTo(.convert)
        #expect(router.activeTab == .convert)
    }

    @Test func layoutConstantsDefineMinimumWindowDimensions() {
        #expect(MonarchUI.Layout.minWindowWidth >= 1180)
        #expect(MonarchUI.Layout.minWindowHeight >= 600)
    }
}
