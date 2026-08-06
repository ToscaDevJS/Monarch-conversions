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

@Observable
final class UserSettings {
    @ObservationIgnored
    private let appearanceKey = "monarch.userSettings.appearance"
    
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
    
    var displayLanguage: String = "English (United States)"
    var dateFormat: String = "Jul 31, 2026"
    var notifyOnFinish: Bool = true
    
    var preferredColorScheme: ColorScheme? {
        appearance.colorScheme
    }
}
