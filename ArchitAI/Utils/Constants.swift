import SwiftUI

enum Constants {
    enum API {
        static let stabilityAPIKey = "sk-zQjAxj4nmWXN5y72LIq1meKvEGCkPXrSmvGhc0zYWzDhSqlY"
        static let stabilityBaseURL = "https://api.stability.ai/v1"
        static let defaultEngine = "stable-diffusion-xl-1024-v1-0"
        static let defaultSteps = 25
        static let defaultCFGScale = 6.5
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
