import SwiftUI

struct DesignOptionCard: View {
    let title: String
    let subtitle: String
    let beforeImage: String
    let afterImage: String
    let action: () -> Void
    
    @State private var showingAfterImage = false
    @State private var isAnimating = true
    @State private var isHovered = false
    @Environment(\.colorScheme) var colorScheme
    
    private let animationDuration: Double = 2.0
    private let pauseDuration: Double = 1.0
    
    private func startAnimation() {
        guard isAnimating else { return }
        
        withAnimation(.easeInOut(duration: animationDuration)) {
            showingAfterImage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + pauseDuration) {
            guard isAnimating else { return }
            
            withAnimation(.easeInOut(duration: animationDuration)) {
                showingAfterImage = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + pauseDuration) {
                guard isAnimating else { return }
                startAnimation()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Hero Image Section
            ZStack {
                GeometryReader { proxy in
                    let imageHeight = isIPad ? min(proxy.size.width * 0.75, 350) : 250
                    
                    ZStack {
                        // Background
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: imageHeight)
                        
                        // Images
                        ZStack {
                            // Before Image
                            Image(beforeImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: imageHeight)
                                .clipped()
                            
                            // After Image with opacity animation
                            Image(afterImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: imageHeight)
                                .clipped()
                                .opacity(showingAfterImage ? 1 : 0)
                        }
                        
                        // Overlay gradient for better text readability
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color.black.opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: imageHeight)
                        
                        // Before/After Label
                        VStack {
                            Spacer()
                            HStack {
                                Text(showingAfterImage ? "after".localized : "before".localized)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(Color.white.opacity(0.2))
                                            .background(
                                                Capsule()
                                                    .fill(.ultraThinMaterial)
                                            )
                                    )
                                    .padding(.leading, 20)
                                    .padding(.bottom, 20)
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
            .onAppear {
                startAnimation()
            }
            .onChange(of: isAnimating) { newValue in
                if newValue {
                    startAnimation()
                }
            }
            .frame(height: isIPad ? 350 : 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .contentShape(Rectangle())
            .onTapGesture {
                // Görsel bölümüne dokununca da Create akşına geç
                action()
            }
            
            // Content Section - Clickable area only
            Button(action: action) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(title)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Constants.Colors.textPrimary)
                                .multilineTextAlignment(.leading)
                            
                            Text(subtitle)
                                .font(.system(size: 15))
                                .foregroundColor(Constants.Colors.textSecondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        // Arrow indicator
                        Image(systemName: "arrow.up.right.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Constants.Colors.textPrimary)
                            .opacity(isHovered ? 1.0 : 0.7)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Constants.Colors.cardBackground)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .background(Constants.Colors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Constants.Colors.cardBorder, lineWidth: 1)
        )
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.08), radius: 15, x: 0, y: 5)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
            isAnimating = !hovering
        }
        .onAppear {
            showingAfterImage = false
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
}
