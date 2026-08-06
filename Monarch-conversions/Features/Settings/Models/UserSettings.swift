import SwiftUI

enum AppearanceOption: String, CaseIterable, Identifiable, Codable {
    case dark = "Dark"
    case light = "Light"
    case system = "System Setting"
    
    var id: String { rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .dark: return .dark
        case .light: return .light
        case .system: return nil
        }
    }
}

enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case english = "en"
    case spanish = "es"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English (United States)"
        case .spanish: return "Español"
        }
    }
    
    var locale: Locale {
        Locale(identifier: rawValue)
    }
}

@Observable
final class UserSettings {
    @ObservationIgnored
    private let appearanceKey = "monarch.userSettings.appearance"
    
    @ObservationIgnored
    private let languageKey = "monarch.userSettings.language"
    
    var appearance: AppearanceOption {
        get {
            access(keyPath: \.appearance)
            if let saved = UserDefaults.standard.string(forKey: appearanceKey),
               let option = AppearanceOption(rawValue: saved) {
                return option
            }
            return .dark
        }
        set {
            withMutation(keyPath: \.appearance) {
                UserDefaults.standard.set(newValue.rawValue, forKey: appearanceKey)
            }
        }
    }
    
    var language: AppLanguage {
        get {
            access(keyPath: \.language)
            if let saved = UserDefaults.standard.string(forKey: languageKey),
               let option = AppLanguage(rawValue: saved) {
                return option
            }
            return .english
        }
        set {
            withMutation(keyPath: \.language) {
                UserDefaults.standard.set(newValue.rawValue, forKey: languageKey)
            }
        }
    }
    
    var displayLanguage: String {
        language.displayName
    }
    
    var dateFormat: String = "Jul 31, 2026"
    var notifyOnFinish: Bool = true
    
    var preferredColorScheme: ColorScheme? {
        appearance.colorScheme
    }
}
