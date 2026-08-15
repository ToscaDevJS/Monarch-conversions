import Testing
import SwiftUI
@testable import Monarch_conversions

@MainActor
@Suite(.serialized)
struct MonarchUITests {

    @Test func dynamicColorTokensInitializeSuccessfully() async throws {
        let tokens = [
            MonarchUI.Color.background,
            MonarchUI.Color.surface,
            MonarchUI.Color.textPrimary,
            MonarchUI.Color.accentViolet
        ]

        #expect(tokens.count == 4)
    }

    @Test func colorSchemeMappingCoversAllCases() async throws {
        #expect(AppearanceOption.dark.colorScheme == .dark)
        #expect(AppearanceOption.light.colorScheme == .light)
        #expect(AppearanceOption.system.colorScheme == nil)
    }
}
