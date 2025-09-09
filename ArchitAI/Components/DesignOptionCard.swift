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
        VStack(spacing: 0) {
            // Hero Image Section
            ZStack {
                // Background for slider
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 250)
                
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
                
                // Before/After Overlay Slider
                GeometryReader { geometry in
                    ZStack {
                        // After Image (Background)
                        Image(afterImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width)
                            .frame(height: 250)
                            .clipped()
                            .allowsHitTesting(false) // Disable interaction
                        
                        // Before Image (Overlay)
                        Image(beforeImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width)
                            .frame(height: 250)
                            .clipped()
                            .allowsHitTesting(false) // Disable interaction
                            .mask(
                                Rectangle()
                                    .frame(width: geometry.size.width * sliderPosition)
                                    .frame(height: 250)
                                    .offset(x: -geometry.size.width * (1 - sliderPosition) / 2)
                            )
                    }
                    .overlay(
                        // Slim line with central white handle containing left/right arrows
                        ZStack {
                            // Main vertical line (full height, thinner)
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 2, height: geometry.size.height)
                                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 0)

                            // Central circular handle with arrows
                            Circle()
                                .fill(Color.white)
                                .frame(width: 32, height: 32)
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                                .overlay(
                                    HStack(spacing: 6) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.black)
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                )
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            if !isDragging {
                                                isDragging = true
                                            }
                                            let newPosition = (value.location.x + geometry.size.width/2) / geometry.size.width
                                            withAnimation(.easeOut(duration: 0.1)) {
                                                sliderPosition = max(0, min(1, newPosition))
                                            }
                                        }
                                        .onEnded { _ in
                                            isDragging = false
                                            Constants.Haptics.selection()
                                        }
                                )
                        }
                        .offset(x: geometry.size.width * sliderPosition - geometry.size.width/2)
                    )
                    // Disable general gesture on the whole view
                }
                
                // Interactive Slider
                VStack {
                    Spacer()
                    
                    HStack {
                        // Before/After Toggle Button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                sliderPosition = sliderPosition > 0.5 ? 0.0 : 1.0
                            }
                            Constants.Haptics.selection()
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
                                    .fill(isDragging ? Color.white.opacity(0.3) : Color.white.opacity(0.2))
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
        }
        .onAppear {
            sliderPosition = 0.5
        }
    }
}
