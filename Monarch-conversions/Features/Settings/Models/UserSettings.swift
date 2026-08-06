import SwiftUI

enum AppearanceOption: String, CaseIterable, Identifiable {
    case dark = "Dark"
    case light = "Light"
    case system = "System Setting"
    
    var id: String { rawValue }
}

@Observable
final class UserSettings {
    var appearance: AppearanceOption = .dark
    var displayLanguage: String = "English (United States)"
    var dateFormat: String = "Jul 31, 2026"
    var notifyOnFinish: Bool = true
}
