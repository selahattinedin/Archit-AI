import SwiftUI

struct LoadingView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            // Loading Animation
            VStack(spacing: 40) {
                // Lottie Loading Animation
                LottieView(name: "Loading", loopMode: .loop, animationSpeed: 1.0)
                    .frame(width: 120, height: 120)
                
                Text("please_wait_designing".localized)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}
