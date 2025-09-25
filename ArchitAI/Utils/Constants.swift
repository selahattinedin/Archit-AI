import SwiftUI

enum Constants {
    enum API {
        // API anahtarları Config.plist dosyasından güvenli şekilde okunur
        static var stabilityAPIKey: String {
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: path),
                  let apiKey = plist["STABILITY_AI_API_KEY"] as? String else {
                fatalError("STABILITY_AI_API_KEY not found in Config.plist")
            }
            return apiKey
        }
        
        static var stabilityBaseURL: String {
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: path),
                  let baseURL = plist["STABILITY_AI_BASE_URL"] as? String else {
                return "https://api.stability.ai/v1" // fallback
            }
            return baseURL
        }
        
        static var defaultEngine: String {
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: path),
                  let engine = plist["DEFAULT_ENGINE"] as? String else {
                return "stable-diffusion-xl-1024-v1-0" // fallback
            }
            return engine
        }
        
        static var defaultSteps: Int {
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: path),
                  let steps = plist["DEFAULT_STEPS"] as? Int else {
                return 25 // fallback
            }
            return steps
        }
        
        static var defaultCFGScale: Double {
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let plist = NSDictionary(contentsOfFile: path),
                  let cfgScale = plist["DEFAULT_CFG_SCALE"] as? Double else {
                return 6.5 // fallback
            }
            return cfgScale
        }
    }
    
    enum Colors {
        static let cardBackground = Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0) : // Dark mode
                UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)   // Light mode
        })
        
        static let cardBorder = Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0) : // Dark mode
                UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)   // Light mode
        })
        
        static let textPrimary = Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                .white : .black
        })
        
        static let textSecondary = Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                UIColor(white: 0.7, alpha: 1.0) : // Dark mode
                UIColor(white: 0.5, alpha: 1.0)   // Light mode
        })
        
        static let buttonBackground = Color.black
        static let buttonText = Color.white
        
        // Pro badge rengi - dark mode'da da aynı kalacak
        static let proBackground = Color(uiColor: UIColor(red: 0.98, green: 0.47, blue: 0.0, alpha: 1.0))
        
        // Premium orange rengi - proBackground ile aynı
        static let PremiumOrange = proBackground

        // Premium red theme for paywall (closer to provided references)
        static let PremiumRed = Color(red: 0.90, green: 0.12, blue: 0.16)
    }
    
    enum Spacing {
        static let xxxsmall: CGFloat = 4
        static let xxsmall: CGFloat = 8
        static let xsmall: CGFloat = 12
        static let small: CGFloat = 16
        static let medium: CGFloat = 24
        static let large: CGFloat = 32
        static let xlarge: CGFloat = 40
        static let xxlarge: CGFloat = 48
    }
    
    enum FontSize {
        static let caption: CGFloat = 12
        static let body: CGFloat = 16
        static let title3: CGFloat = 20
        static let title2: CGFloat = 24
        static let title1: CGFloat = 32
        static let largeTitle: CGFloat = 40
    }
    
    enum Layout {
        static let cornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 56
        static let cardPadding: CGFloat = 16
        static let maxWidth: CGFloat = 500
        static let imageAspectRatio: CGFloat = 4/3
    }
    
    enum Animations {
        static let defaultSpring = Animation.spring(
            response: 0.3,
            dampingFraction: 0.7,
            blendDuration: 0.3
        )
        
        static let slowSpring = Animation.spring(
            response: 0.5,
            dampingFraction: 0.8,
            blendDuration: 0.5
        )
        
        static let quickSpring = Animation.spring(
            response: 0.2,
            dampingFraction: 0.5,
            blendDuration: 0.2
        )
    }
    
    enum Haptics {
        static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
        
        static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(type)
        }
        
        static func selection() {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
