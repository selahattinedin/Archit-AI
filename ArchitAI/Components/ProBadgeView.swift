import SwiftUI

struct ProBadgeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "sparkles")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
            
            Text("PREMIUM")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .kerning(0.5)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.47, blue: 0.0),
                    Color(red: 1.0, green: 0.62, blue: 0.0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(Capsule())
        .shadow(color: Color(red: 0.98, green: 0.47, blue: 0.0).opacity(0.3), radius: 8, x: 0, y: 4)
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    VStack {
        ProBadgeView()
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}