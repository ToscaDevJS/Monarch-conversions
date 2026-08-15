import Testing
import SwiftUI
@testable import Monarch_conversions

@MainActor
@Suite(.serialized)
struct UserSettingsTests {

    @Test func defaultAppearanceIsDark() async throws {
        let userDefaultsKey = "monarch.userSettings.appearance"
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        
        let settings = UserSettings()
        #expect(settings.appearance == .dark)
        #expect(settings.preferredColorScheme == .dark)
    }

    @Test func appearancePersistence() async throws {
        let userDefaultsKey = "monarch.userSettings.appearance"
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        
        let settings = UserSettings()
        settings.appearance = .light
        
        #expect(UserDefaults.standard.string(forKey: userDefaultsKey) == "Light")
        #expect(settings.preferredColorScheme == .light)
        
        settings.appearance = .system
        #expect(UserDefaults.standard.string(forKey: userDefaultsKey) == "System Setting")
        #expect(settings.preferredColorScheme == nil)
    }

    @Test func colorSchemeMapping() async throws {
        #expect(AppearanceOption.dark.colorScheme == .dark)
        #expect(AppearanceOption.light.colorScheme == .light)
        #expect(AppearanceOption.system.colorScheme == nil)
    }

    @Test func defaultLanguageIsEnglish() async throws {
        let languageKey = "monarch.userSettings.language"
        UserDefaults.standard.removeObject(forKey: languageKey)
        
        let settings = UserSettings()
        #expect(settings.language == .english)
        #expect(settings.language.locale.identifier == "en")
    }

    @Test func languagePersistence() async throws {
        let languageKey = "monarch.userSettings.language"
        UserDefaults.standard.removeObject(forKey: languageKey)
        
        let settings = UserSettings()
        settings.language = .spanish
        
        #expect(UserDefaults.standard.string(forKey: languageKey) == "es")
        #expect(settings.language == .spanish)
        #expect(settings.language.locale.identifier == "es")
    }

    @Test func languageLocaleMapping() async throws {
        #expect(AppLanguage.english.locale.identifier == "en")
        #expect(AppLanguage.spanish.locale.identifier == "es")
        #expect(AppLanguage.english.displayName == "English (United States)")
        #expect(AppLanguage.spanish.displayName == "Español")
    }
}
