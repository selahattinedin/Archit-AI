import SwiftUI

// MARK: - View Extensions
extension View {
    /// Belirli köşelere yuvarlaklık ekler
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    /// Haptic feedback uygular
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

// MARK: - Custom Shapes
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                              byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}// MARK: - Color Extensions
extension Color {
    static func random(opacity: Double = 1.0) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: opacity
        )
    }
}

// MARK: - Animation Extensions
extension Animation {
    static var smoothSpring: Animation {
        spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.3)
    }
    
    static var quickSpring: Animation {
        spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.2)
    }
}

