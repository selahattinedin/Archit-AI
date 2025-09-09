import SwiftUI

struct BeforeAfterSliderView: View {
    let beforeImage: UIImage
    let afterImage: UIImage
    @State private var sliderPosition: CGFloat = 0.5
    @State private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Images and Slider Container
                ZStack {
                    // After Image
                    Image(uiImage: afterImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height - 60) // Subtract space for labels
                        .allowsHitTesting(false) // Disable interaction
                    
                    // Before Image - Clipped with slider
                    Image(uiImage: beforeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height - 60) // Subtract space for labels
                        .allowsHitTesting(false) // Disable interaction
                        .mask(
                            Rectangle()
                                .size(
                                    width: geometry.size.width * sliderPosition,
                                    height: geometry.size.height - 60
                                )
                        )
                    
                    // Slider Line
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 3, height: geometry.size.height - 60)
                        .position(x: geometry.size.width * sliderPosition, y: (geometry.size.height - 60) / 2)
                        .shadow(color: .black.opacity(0.3), radius: 4)
                    
                    // Slider Handle with Gesture
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.3), radius: isDragging ? 8 : 4)
                        .overlay(
                            Image(systemName: "arrow.left.and.right.circle.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black.opacity(0.6))
                        )
                        .position(x: geometry.size.width * sliderPosition, y: (geometry.size.height - 60) / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    withAnimation(.interactiveSpring()) {
                                        let newPosition = value.location.x / geometry.size.width
                                        sliderPosition = min(max(newPosition, 0), 1)
                                    }
                                    Constants.Haptics.selection()
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    Constants.Haptics.impact(.light)
                                }
                        )
                }
                
                // Labels
                HStack {
                    if sliderPosition > 0.1 {
                        Text("Before")
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                            .padding(.leading, 16)
                            .transition(.opacity.combined(with: .move(edge: .leading)))
                    }
                    
                    Spacer()
                    
                    if sliderPosition < 0.9 {
                        Text("After")
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                            .padding(.trailing, 16)
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .padding(.bottom, 16)
                .animation(Constants.Animations.defaultSpring, value: sliderPosition)
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius))
        }
    }
}

#Preview {
    BeforeAfterSliderView(
        beforeImage: UIImage(named: "room_before") ?? UIImage(),
        afterImage: UIImage(named: "room_after") ?? UIImage()
    )
    .frame(height: 300)
    .padding()
}