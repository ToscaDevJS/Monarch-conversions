import Testing
import SwiftUI
@testable import Monarch_conversions

@Suite(.serialized)
struct MonarchUITests {

    @Test func dynamicColorTokensInitializeSuccessfully() async throws {
        let background = MonarchUI.Color.background
        let surface = MonarchUI.Color.surface
        let textPrimary = MonarchUI.Color.textPrimary
        let accentViolet = MonarchUI.Color.accentViolet
        
        #expect(background != nil)
        #expect(surface != nil)
        #expect(textPrimary != nil)
        #expect(accentViolet != nil)
    }

    @Test func colorSchemeMappingCoversAllCases() async throws {
        #expect(AppearanceOption.dark.colorScheme == .dark)
        #expect(AppearanceOption.light.colorScheme == .light)
        #expect(AppearanceOption.system.colorScheme == nil)
    }
}
