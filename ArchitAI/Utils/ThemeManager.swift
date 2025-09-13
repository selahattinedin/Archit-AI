import SwiftUI

enum Theme: String {
    case light
    case dark
    case system
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    
    var icon: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        case .system:
            return "gear"
        }
    }
    
    var text: String {
        switch self {
        case .light:
            return "light_theme".localized
        case .dark:
            return "dark_theme".localized
        case .system:
            return "system_theme".localized
        }
    }
}
