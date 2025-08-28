import SwiftUI

struct DesignOptionCard: View {
    let title: String
    let subtitle: String
    let beforeImage: String
    let afterImage: String
    let action: () -> Void
    
    @State private var sliderPosition: CGFloat = 0.5
    @State private var isDragging = false
    @State private var isHovered = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                // Hero Image Section
                ZStack {
                    // Background Image (After)
                    Image(afterImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                    
                    // Overlay gradient for better text readability
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.black.opacity(0.3)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 250)
                    
                    // Before/After Reveal Section
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            // Before Section
                            Image(beforeImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width * sliderPosition)
                                .frame(height: 250)
                                .clipped()
                            
                            Spacer(minLength: 0)
                        }
                    }
                    
                    // Interactive Slider
                    VStack {
                        Spacer()
                        
                        HStack {
                            // Before/After Toggle Button
                            Button(action: {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                    sliderPosition = sliderPosition > 0.5 ? 0.0 : 1.0
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Text(sliderPosition > 0.5 ? "Before" : "After")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: sliderPosition > 0.5 ? "arrow.left" : "arrow.right")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                }
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
                            }
                            .padding(.leading, 20)
                            
                            Spacer()
                        }
                        .padding(.bottom, 20)
                    }
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Content Section
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
        }
        .buttonStyle(PlainButtonStyle())
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
        }
        .onAppear {
            // Auto-animate on appear for demo effect
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    sliderPosition = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeInOut(duration: 2.0)) {
                        sliderPosition = 1.0
                    }
                }
            }
        }
        .onTapGesture {
            action()
        }
    }
}