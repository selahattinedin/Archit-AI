import SwiftUI

struct PhotoUploadView: View {
    @Binding var selectedImage: UIImage?
    @State private var isShowingActionSheet = false
    @State private var isShowingCamera = false
    @State private var isShowingLibrary = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            // Photo Display Area - Larger
            ZStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Constants.Colors.cardBorder, lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                        .overlay(
                            Button {
                                selectedImage = nil
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(
                                        Circle()
                                            .fill(colorScheme == .dark ? 
                                                Color.black.opacity(0.6) : 
                                                Color.white.opacity(0.6)
                                            )
                                    )
                            }
                            .padding(12),
                            alignment: .topTrailing
                        )
                } else {
                    // Upload Container - Larger with content inside
                    ZStack {
                        // Background gradient
                        LinearGradient(
                            colors: [
                                colorScheme == .dark ? 
                                    Color.gray.opacity(0.1) : 
                                    Color.blue.opacity(0.05),
                                colorScheme == .dark ? 
                                    Color.gray.opacity(0.05) : 
                                    Color.purple.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        // Dashed border
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        colorScheme == .dark ? 
                                            Color.gray.opacity(0.4) : 
                                            Color.blue.opacity(0.3),
                                        colorScheme == .dark ? 
                                            Color.gray.opacity(0.2) : 
                                            Color.purple.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 2, dash: [8, 6])
                            )
                        
                        // Content inside the frame
                        VStack(spacing: 20) {
                            // Icon with background
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                colorScheme == .dark ? 
                                                    Color.gray.opacity(0.2) : 
                                                    Color.blue.opacity(0.1),
                                                colorScheme == .dark ? 
                                                    Color.gray.opacity(0.1) : 
                                                    Color.purple.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(
                                        colorScheme == .dark ? 
                                            .gray.opacity(0.7) : 
                                            .blue.opacity(0.8)
                                    )
                            }
                            
                            VStack(spacing: 12) {
                                Text("Select a photo to transform")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(
                                        colorScheme == .dark ? 
                                            .gray.opacity(0.8) : 
                                            .primary.opacity(0.8)
                                    )
                                
                                Text("Tap to choose from gallery or take a photo")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(
                                        colorScheme == .dark ? 
                                            .gray.opacity(0.6) : 
                                            .secondary
                                    )
                                    .multilineTextAlignment(.center)
                                
                                // Small Upload Button
                                Button {
                                    isShowingActionSheet = true
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 14, weight: .medium))
                                        Text("Upload Photo")
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    .foregroundColor(colorScheme == .dark ? .black : .white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(colorScheme == .dark ? Color.white : Color.black)
                                    .clipShape(Capsule())
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .onTapGesture {
                        isShowingActionSheet = true
                    }
                }
            }
            
            // Example Photos - Moved to bottom (above continue button)
            VStack(alignment: .leading, spacing: 16) {
                Text("Example Photos")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Constants.Colors.textPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach([
                            "new_room",
                            "new_bathroom",
                            "new_bedroom",
                            "new_garden",
                            "new_balcony"
                        ], id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 140, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Constants.Colors.cardBorder, lineWidth: 1)
                                )
                                .onTapGesture {
                                    if let image = UIImage(named: imageName) {
                                        selectedImage = image
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .confirmationDialog("Choose Photo", isPresented: $isShowingActionSheet) {
            Button("Take Photo") {
                isShowingCamera = true
            }
            Button("Choose from Library") {
                isShowingLibrary = true
            }
            if selectedImage != nil {
                Button("Remove Photo", role: .destructive) {
                    selectedImage = nil
                }
            }
        }
        .sheet(isPresented: $isShowingCamera) {
            ImagePicker(sourceType: .camera) { image in
                selectedImage = image
            }
        }
        .sheet(isPresented: $isShowingLibrary) {
            ImagePicker(sourceType: .photoLibrary) { image in
                selectedImage = image
            }
        }
    }
}
