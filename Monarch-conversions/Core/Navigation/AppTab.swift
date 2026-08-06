import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case studio = "STUDIO"
    case convert = "CONVERT"
    case settings = "SETTINGS"
    
    var id: String { rawValue }
}
