import SwiftUI
import PhotosUI

struct PhotoUploadView: View {
    @Binding var selectedImage: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var isShowingPhotoPicker = false
    @State private var isShowingActionSheet = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 20) {
                ZStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: 280)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(Constants.Colors.cardBorder, lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                            .overlay(
                                Button {
                                    isShowingActionSheet = true
                                } label: {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Circle())
                                }
                                .padding(12),
                                alignment: .topTrailing
                            )
                    } else {
                        // Upload Container
                        VStack(spacing: 16) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 32))
                                .foregroundColor(.gray.opacity(0.8))
                            
                            Text("Select a photo to transform")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.gray.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .background(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(Constants.Colors.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .stroke(Constants.Colors.cardBorder, lineWidth: 1)
                                )
                        )
                    }
                }
                .frame(height: 280)
                
                // Upload Button
                Button {
                    isShowingActionSheet = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 18, weight: .medium))
                        Text("Upload Photo")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(height: 46)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .clipShape(Capsule())
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, 20)
            }
            
            // Example Photos
            VStack(alignment: .leading, spacing: 16) {
                Text("Example Photos")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Constants.Colors.textPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach([
                            "old_room",
                            "old_bathroom",
                            "new_room",
                            "new_bathroom",
                            "old_room",
                            "old_bathroom"
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
                isShowingPhotoPicker = true
            }
            Button("Choose from Library") {
                isShowingPhotoPicker = true
            }
            if selectedImage != nil {
                Button("Remove Photo", role: .destructive) {
                    selectedImage = nil
                }
            }
        }
        .photosPicker(
            isPresented: $isShowingPhotoPicker,
            selection: $photosPickerItem,
            matching: .images
        )
        .onChange(of: photosPickerItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = image
                    }
                }
            }
        }
    }
}
