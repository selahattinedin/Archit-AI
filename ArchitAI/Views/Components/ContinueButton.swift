import SwiftUI

struct ContinueButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    init(
        title: String,
        icon: String? = "arrow.right",
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .dark ? .black : .white))
                        .scaleEffect(1.1)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(colorScheme == .dark ? Color.white : Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.25),
                radius: 12,
                x: 0,
                y: 6
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        ContinueButton(title: "Continue", action: {})
        ContinueButton(title: "Transform Room", icon: "wand.and.stars", action: {})
        ContinueButton(title: "Generating...", isLoading: true, isEnabled: false, action: {})
    }
    .padding()
}
