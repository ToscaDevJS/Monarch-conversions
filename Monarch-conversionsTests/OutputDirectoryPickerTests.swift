import Foundation
import Testing
@testable import Monarch_conversions

@Suite struct OutputDirectoryPickerTests {
    @Test func defaultOutputDirectoryIsNil() {
        let settings = ConversionSettings()
        #expect(settings.outputDirectoryURL == nil)
    }

    @Test func outputDirectoryCanBeAssignedAndCleared() {
        var settings = ConversionSettings()
        let customDir = URL(fileURLWithPath: "/tmp/custom_conversions")
        settings.outputDirectoryURL = customDir

        #expect(settings.outputDirectoryURL?.path == "/tmp/custom_conversions")

        settings.outputDirectoryURL = nil
        #expect(settings.outputDirectoryURL == nil)
    }
}
