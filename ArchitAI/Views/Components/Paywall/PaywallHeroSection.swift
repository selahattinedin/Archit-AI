import SwiftUI

struct PaywallHeroSection: View {
    @State private var showAfterDesign = false
    @State private var isGlowing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Before/After Design Animation
            ZStack {
                // Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.05, green: 0.05, blue: 0.1),
                        Color(red: 0.1, green: 0.05, blue: 0.15),
                        Color.black
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Subtle animated circles
                Circle()
                    .fill(Constants.Colors.PremiumOrange.opacity(0.08))
                    .frame(width: 180, height: 180)
                    .offset(x: isGlowing ? 40 : -40, y: isGlowing ? -20 : 20)
                    .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: isGlowing)
                
                Circle()
                    .fill(Constants.Colors.PremiumOrange.opacity(0.05))
                    .frame(width: 120, height: 120)
                    .offset(x: isGlowing ? -30 : 30, y: isGlowing ? 40 : -40)
                    .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: isGlowing)
                
                VStack(spacing: 32) {
                    // Premium Badge - Beyaz ve şık
                    HStack(spacing: 14) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                        
                        Text("PREMIUM")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .tracking(3)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                    .padding(.top, 80)
                    
                    // Before/After Images - Daha büyük ve şık
                    ZStack {
                        // Before Image (Old Room)
                        Image("old_room")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 400, height: 300)
                            .clipped()
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .overlay(
                                Text("Before")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(12)
                                    .padding(16)
                                , alignment: .topLeading
                            )
                            .opacity(showAfterDesign ? 0 : 1)
                            .scaleEffect(showAfterDesign ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 1.0), value: showAfterDesign)
                            .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 8)
                        
                        // After Image (New Room)
                        Image("new_room")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 400, height: 300)
                            .clipped()
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Constants.Colors.PremiumOrange.opacity(0.6), lineWidth: 2)
                            )
                            .overlay(
                                Text("After")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .background(Constants.Colors.PremiumOrange.opacity(0.9))
                                    .cornerRadius(12)
                                    .padding(16)
                                , alignment: .topLeading
                            )
                            .opacity(showAfterDesign ? 1 : 0)
                            .scaleEffect(showAfterDesign ? 1.0 : 0.9)
                            .animation(.easeInOut(duration: 1.0), value: showAfterDesign)
                            .shadow(color: Constants.Colors.PremiumOrange.opacity(0.4), radius: 20, x: 0, y: 12)
                    }
                    
                    // Kısa Açıklama - Daha şık
                    Text("Transform your space with AI")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 20)
                        .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 2)
                    
                    Spacer()
                }
            }
            .frame(height: 450)
            .onAppear {
                // Start animations
                isGlowing = true
                
                // Start before/after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        showAfterDesign = true
                    }
                }
                
                // Loop the before/after animation
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 1.0)) {
                        showAfterDesign.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    PaywallHeroSection()
        .background(Color.black)
}
