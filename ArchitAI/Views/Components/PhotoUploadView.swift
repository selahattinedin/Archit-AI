import SwiftUI

struct PhotoUploadView: View {
    @Binding var selectedImage: UIImage?
    @State private var isShowingActionSheet = false
    @State private var isShowingCamera = false
    @State private var isShowingLibrary = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 60 : 24) {
            // Photo Display Area - Larger
            ZStack {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 600 : 350)
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
                                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 100 : 80,
                                           height: UIDevice.current.userInterfaceIdiom == .pad ? 100 : 80)
                                
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 44 : 32, weight: .medium))
                                    .foregroundColor(
                                        colorScheme == .dark ? 
                                            .gray.opacity(0.7) : 
                                            .blue.opacity(0.8)
                                    )
                            }
                            
                            VStack(spacing: 12) {
                                Text("select_photo".localized)
                                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 18, weight: .semibold))
                                    .foregroundColor(
                                        colorScheme == .dark ? 
                                            .gray.opacity(0.8) : 
                                            .primary.opacity(0.8)
                                    )
                                
                                Text("tap_to_choose".localized)
                                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 18 : 14, weight: .regular))
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
                                            .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 18 : 14, weight: .medium))
                                        Text("upload_photo".localized)
                                            .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 18 : 14, weight: .medium))
                                    }
                                    .foregroundColor(colorScheme == .dark ? .black : .white)
                                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 24 : 16)
                                    .padding(.vertical, UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8)
                                    .background(colorScheme == .dark ? Color.white : Color.black)
                                    .clipShape(Capsule())
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 600 : 350)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .onTapGesture {
                        isShowingActionSheet = true
                    }
                }
            }
            
            // Example Photos - Moved to bottom (above continue button)
            VStack(alignment: .leading, spacing: UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16) {
                Text("example_photos".localized)
                    .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 22 : 17, weight: .semibold))
                    .foregroundColor(Constants.Colors.textPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 12) {
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
                                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 320 : 140,
                                       height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 100)
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
                    .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 30 : 1)
                    .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 30 : 0)
                }
            }
        }
        .confirmationDialog("choose_photo".localized, isPresented: $isShowingActionSheet) {
            Button("take_photo".localized) {
                isShowingCamera = true
            }
            Button("choose_from_library".localized) {
                isShowingLibrary = true
            }
            if selectedImage != nil {
                Button("remove_photo".localized, role: .destructive) {
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