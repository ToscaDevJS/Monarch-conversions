import Testing
import Foundation
@testable import Monarch_conversions

@Suite
struct AppLocalizationTests {

    @Test func appLanguageLocalesAreCorrect() async throws {
        #expect(AppLanguage.english.locale.identifier == "en")
        #expect(AppLanguage.spanish.locale.identifier == "es")
    }

    @Test func localizedStringKeysResolveInDomainBundles() async throws {
        class TestBundleToken {}
        let bundle = Bundle(for: TestBundleToken.self)
        
        let studioString = NSLocalizedString("nav.studio", tableName: "Common", bundle: bundle, value: "STUDIO", comment: "")
        #expect(!studioString.isEmpty)
        
        let convertTitle = NSLocalizedString("header.convert_title", tableName: "Conversions", bundle: bundle, value: "Batch Image Conversion", comment: "")
        #expect(!convertTitle.isEmpty)
        
        let settingsTitle = NSLocalizedString("header.settings_title", tableName: "Settings", bundle: bundle, value: "Workspace Preferences", comment: "")
        #expect(!settingsTitle.isEmpty)
    }
}
