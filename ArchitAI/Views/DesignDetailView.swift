import SwiftUI

struct DesignDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var homeViewModel: HomeViewModel
    let design: Design
    let isFromCreate: Bool // Create'den mi geliyor yoksa History'den mi
    let onSave: (() -> Void)? // Save callback (sadece Create'den gelince)
    let onClose: (() -> Void)? // Close callback (Create'de X'e basılınca step 1'e dönmek için)
    
    
    
    // Design'ın kaydedilip kaydedilmediğini kontrol et
    private var isDesignSaved: Bool {
        homeViewModel.designs.contains { $0.id == design.id }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Close Button Header
            HStack {
                Spacer()
                
                Button {
                    // Hemen dismiss et
                    onClose?()
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.6))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Before-After Images
                    VStack(spacing: 20) {
                        
                        // BEFORE
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Before")
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .gray)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Constants.Colors.cardBackground)
                                    .frame(height: 300)
                                
                                // Önce UIImage'den dene, yoksa URL'den yükle
                                if let image = design.beforeImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 300)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                } else if let imageData = design.beforeImageData,
                                          let image = UIImage(data: imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 300)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                } else if let url = design.beforeImageURL {
                                    // URL'den yükle
                                    AsyncImage(url: URL(string: url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                            ProgressView()
                                                .scaleEffect(0.8)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                            }
                        }
                        
                        // AFTER
                        VStack(alignment: .leading, spacing: 8) {
                            Text("After")
                                .font(.subheadline)
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .gray)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Constants.Colors.cardBackground)
                                    .frame(height: 300)
                                
                                // Önce UIImage'den dene, yoksa URL'den yükle
                                if let image = design.afterImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 300)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                } else if let imageData = design.afterImageData,
                                          let image = UIImage(data: imageData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 300)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                } else if let url = design.afterImageURL {
                                    // URL'den yükle
                                    AsyncImage(url: URL(string: url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.2))
                                            ProgressView()
                                                .scaleEffect(0.8)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Design Info
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Room Type")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(design.room.name)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Style")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(design.style.name)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(design.style.description)
                                .font(.body)
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.9) : .black.opacity(0.8))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(Constants.Colors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Constants.Colors.cardBorder, lineWidth: 1)
                    )
                    .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.08), radius: 15, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            // SHARE Button - Her zaman göster
                            Button {
                                print("Share butonuna tıklandı")
                                print("design.afterImage: \(design.afterImage != nil)")
                                print("design.afterImageData: \(design.afterImageData != nil)")
                                print("design.afterImageURL: \(design.afterImageURL ?? "nil")")
                                
                                // Share işlemini başlat
                                Task {
                                    await shareDesign()
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 16))
                                    Text("Share")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .frame(height: 48)
                                .frame(maxWidth: .infinity)
                                .background(colorScheme == .dark ? Color.black : Color.white)
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 1)
                                )
                            }
                            .disabled(design.afterImage == nil && design.afterImageData == nil && design.afterImageURL == nil)
                            .opacity((design.afterImage != nil || design.afterImageData != nil || design.afterImageURL != nil) ? 1.0 : 0.5)
                            
                            // SAVE/DELETE Button - Sadece Create'den gelince göster
                            if isFromCreate {
                                if !isDesignSaved {
                                    // Save butonu
                                    Button {
                                        onSave?()
                                        dismiss()
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "square.and.arrow.down")
                                                .font(.system(size: 16))
                                            Text("Save")
                                                .font(.system(size: 16, weight: .medium))
                                        }
                                        .foregroundColor(.white)
                                        .frame(height: 48)
                                        .frame(maxWidth: .infinity)
                                        .background(Constants.Colors.proBackground)
                                        .cornerRadius(24)
                                    }
                                } else {
                                    // Already saved - Delete butonu
                                    Button {
                                        homeViewModel.removeDesign(design)
                                        dismiss()
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "trash")
                                                .font(.system(size: 16))
                                            Text("Delete")
                                                .font(.system(size: 16, weight: .medium))
                                        }
                                        .foregroundColor(.white)
                                        .frame(height: 48)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .cornerRadius(24)
                                    }
                                }
                            } else {
                                // History'den geliyorsa Share butonu zaten yukarıda, burada boş alan
                                Spacer()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarHidden(true)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .onAppear {
            // View hemen yüklensin
        }
    }
    
    // URL'den image yükleme fonksiyonu
    private func loadImageFromURL(_ urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // HTTP response kontrolü
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                return nil
            }
            
            return UIImage(data: data)
        } catch {
            print("Görsel yüklenemedi: \(urlString) - \(error.localizedDescription)")
            return nil
        }
    }
    
    private func shareDesign() async {
        var activityItems: [Any] = []
        
        if let image = design.afterImage {
            activityItems.append(image)
        } else if let imageData = design.afterImageData,
                  let image = UIImage(data: imageData) {
            activityItems.append(image)
        } else if let url = design.afterImageURL {
            if let image = await loadImageFromURL(url) {
                activityItems.append(image)
            }
        }
        
        if activityItems.isEmpty {
            print("Hiçbir image bulunamadı!")
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
}
