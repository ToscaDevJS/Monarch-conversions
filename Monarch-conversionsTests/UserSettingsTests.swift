import Testing
import SwiftUI
@testable import Monarch_conversions

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
}
