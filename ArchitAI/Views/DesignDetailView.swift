import SwiftUI

struct DesignDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject var homeViewModel: HomeViewModel
    @StateObject private var languageManager = LanguageManager.shared
    @State private var showDeleteAlert = false
    let design: Design
    let isFromCreate: Bool // Create'den mi geliyor yoksa History'den mi
    let onSave: (() -> Void)? // Save callback (sadece Create'den gelince)
    let onClose: (() -> Void)? // Close callback (Create'de X'e basılınca step 1'e dönmek için)
    
    // iPad detection
    private var isTablet: Bool {
        horizontalSizeClass == .regular
    }
    
    
    
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
                VStack(spacing: isTablet ? 32 : 24) {
                    // Before-After Images
                    VStack(spacing: isTablet ? 32 : 20) {
                        
                        // BEFORE
                        VStack(alignment: .leading, spacing: isTablet ? 12 : 8) {
                            Text("before".localized(with: languageManager.languageUpdateTrigger))
                                .font(isTablet ? .title3 : .subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .gray)
                            
                            // Önce UIImage'den dene, yoksa URL'den yükle
                            if let image = design.beforeImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: isTablet ? 900 : .infinity)
                                    .frame(height: isTablet ? 350 : 300)
                                    .background(
                                        RoundedRectangle(cornerRadius: isTablet ? 30 : 25)
                                            .fill(Constants.Colors.cardBackground)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: isTablet ? 30 : 25))
                            } else if let imageData = design.beforeImageData,
                                      let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: isTablet ? 900 : .infinity)
                                    .frame(height: isTablet ? 350 : 300)
                                    .background(
                                        RoundedRectangle(cornerRadius: isTablet ? 30 : 25)
                                            .fill(Constants.Colors.cardBackground)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: isTablet ? 30 : 25))
                            } else if let url = design.beforeImageURL {
                                // URL'den yükle
                                AsyncImage(url: URL(string: url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: isTablet ? 900 : .infinity)
                                    .frame(height: isTablet ? 350 : 300)
                                        .background(
                                            RoundedRectangle(cornerRadius: isTablet ? 30 : 25)
                                                .fill(Constants.Colors.cardBackground)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: isTablet ? 30 : 25))
                                } placeholder: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: isTablet ? 30 : 25)
                                            .fill(Color.gray.opacity(0.2))
                                        ProgressView()
                                            .scaleEffect(isTablet ? 1.2 : 0.8)
                                    }
                                    .frame(maxWidth: isTablet ? 900 : .infinity)
                                    .frame(height: isTablet ? 350 : 300)
                                }
                            }
                        }
                        
                        // AFTER
                        VStack(alignment: .leading, spacing: isTablet ? 12 : 8) {
                            Text("after".localized(with: languageManager.languageUpdateTrigger))
                                .font(isTablet ? .title3 : .subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : .gray)
                            
                            // Önce UIImage'den dene, yoksa URL'den yükle
                            if let image = design.afterImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: isTablet ? 900 : .infinity)
                                    .frame(height: isTablet ? 350 : 300)
                                    .background(
                                        RoundedRectangle(cornerRadius: isTablet ? 30 : 25)
                                            .fill(Constants.Colors.cardBackground)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: isTablet ? 30 : 25))
                            } else if let imageData = design.afterImageData,
                                      let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: isTablet ? 900 : .infinity)
                                    .frame(height: isTablet ? 350 : 300)
                                    .background(
                                        RoundedRectangle(cornerRadius: isTablet ? 30 : 25)
                                            .fill(Constants.Colors.cardBackground)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: isTablet ? 30 : 25))
                            } else if let url = design.afterImageURL {
                                // URL'den yükle
                                AsyncImage(url: URL(string: url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: isTablet ? 900 : .infinity)
                                    .frame(height: isTablet ? 350 : 300)
                                        .background(
                                            RoundedRectangle(cornerRadius: isTablet ? 30 : 25)
                                                .fill(Constants.Colors.cardBackground)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: isTablet ? 30 : 25))
                                } placeholder: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: isTablet ? 30 : 25)
                                            .fill(Color.gray.opacity(0.2))
                                        ProgressView()
                                            .scaleEffect(isTablet ? 1.2 : 0.8)
                                    }
                                    .frame(maxWidth: isTablet ? 900 : .infinity)
                                    .frame(height: isTablet ? 350 : 300)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, isTablet ? 40 : 20)
                    .padding(.top, isTablet ? 30 : 20)
                    
                    // Design Info
                    VStack(alignment: .leading, spacing: isTablet ? 24 : 16) {
                        VStack(alignment: .leading, spacing: isTablet ? 12 : 8) {
                            Text("room_type".localized(with: languageManager.languageUpdateTrigger))
                                .font(isTablet ? .title3 : .subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Text(design.room.localizedName)
                                .font(isTablet ? .title2 : .headline)
                                .fontWeight(.semibold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        
                        VStack(alignment: .leading, spacing: isTablet ? 12 : 8) {
                            Text("style".localized(with: languageManager.languageUpdateTrigger))
                                .font(isTablet ? .title3 : .subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Text(design.style.localizedName)
                                .font(isTablet ? .title2 : .headline)
                                .fontWeight(.semibold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        
                        VStack(alignment: .leading, spacing: isTablet ? 12 : 8) {
                            Text("description".localized(with: languageManager.languageUpdateTrigger))
                                .font(isTablet ? .title3 : .subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Text(design.style.localizedDescription)
                                .font(isTablet ? .title3 : .body)
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.9) : .black.opacity(0.8))
                        }
                    }
                    .frame(maxWidth: isTablet ? 900 : .infinity, alignment: .leading)
                    .padding(isTablet ? 32 : 20)
                    .background(Constants.Colors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: isTablet ? 25 : 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: isTablet ? 25 : 20)
                            .stroke(Constants.Colors.cardBorder, lineWidth: 1)
                    )
                    .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.08), radius: 15, x: 0, y: 5)
                    .padding(.horizontal, isTablet ? 40 : 20)
                    
                    Spacer()
                        .frame(height: isTablet ? 40 : 32)
                    
                    // Action Buttons
                    VStack(spacing: isTablet ? 20 : 16) {
                        HStack(spacing: isTablet ? 20 : 16) {
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
                                HStack(spacing: isTablet ? 12 : 8) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: isTablet ? 20 : 16))
                                    Text("share".localized(with: languageManager.languageUpdateTrigger))
                                        .font(.system(size: isTablet ? 18 : 16, weight: .medium))
                                }
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .frame(height: isTablet ? 56 : 48)
                                .frame(maxWidth: isTablet ? 300 : .infinity)
                                .background(colorScheme == .dark ? Color.white : Color.black)
                                .cornerRadius(isTablet ? 28 : 24)
                            }
                            .disabled(design.afterImage == nil && design.afterImageData == nil && design.afterImageURL == nil)
                            .opacity((design.afterImage != nil || design.afterImageData != nil || design.afterImageURL != nil) ? 1.0 : 0.5)
                            
                            // SAVE/DELETE Button - Create'den gelince göster
                            if isFromCreate {
                                if !isDesignSaved {
                                    // Save butonu
                                    Button {
                                        onSave?()
                                        dismiss()
                                    } label: {
                                        HStack(spacing: isTablet ? 12 : 8) {
                                            Image(systemName: "square.and.arrow.down")
                                                .font(.system(size: isTablet ? 20 : 16))
                                            Text("save".localized(with: languageManager.languageUpdateTrigger))
                                                .font(.system(size: isTablet ? 18 : 16, weight: .medium))
                                        }
                                        .foregroundColor(.white)
                                        .frame(height: isTablet ? 56 : 48)
                                        .frame(maxWidth: isTablet ? 300 : .infinity)
                                        .background(Constants.Colors.proBackground)
                                        .cornerRadius(isTablet ? 28 : 24)
                                    }
                                } else {
                                    // Already saved - Delete butonu
                                    Button {
                                        showDeleteAlert = true
                                    } label: {
                                        HStack(spacing: isTablet ? 12 : 8) {
                                            Image(systemName: "trash")
                                                .font(.system(size: isTablet ? 20 : 16))
                                            Text("delete".localized(with: languageManager.languageUpdateTrigger))
                                                .font(.system(size: isTablet ? 18 : 16, weight: .medium))
                                        }
                                        .foregroundColor(.white)
                                        .frame(height: isTablet ? 56 : 48)
                                        .frame(maxWidth: isTablet ? 300 : .infinity)
                                        .background(Color.red)
                                        .cornerRadius(isTablet ? 28 : 24)
                                    }
                                }
                            } else {
                                // History'den geliyorsa DELETE butonu göster
                                Button {
                                    showDeleteAlert = true
                                } label: {
                                    HStack(spacing: isTablet ? 12 : 8) {
                                        Image(systemName: "trash")
                                            .font(.system(size: isTablet ? 20 : 16))
                                        Text("delete".localized(with: languageManager.languageUpdateTrigger))
                                            .font(.system(size: isTablet ? 18 : 16, weight: .medium))
                                    }
                                    .foregroundColor(.white)
                                    .frame(height: isTablet ? 56 : 48)
                                    .frame(maxWidth: isTablet ? 300 : .infinity)
                                    .background(Color.red)
                                    .cornerRadius(isTablet ? 28 : 24)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, isTablet ? 40 : 20)
                    .padding(.bottom, isTablet ? 40 : 32)
                }
            }
        }
        .navigationBarHidden(true)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .alert("delete_design".localized(with: languageManager.languageUpdateTrigger), isPresented: $showDeleteAlert) {
            Button("delete_design_confirm".localized(with: languageManager.languageUpdateTrigger), role: .destructive) {
                homeViewModel.removeDesign(design)
                dismiss()
            }
            Button("cancel".localized(with: languageManager.languageUpdateTrigger), role: .cancel) { }
        } message: {
            Text("delete_design_message".localized(with: languageManager.languageUpdateTrigger))
        }
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
        var fallbackURLString: String? = nil
        
        if let image = design.afterImage {
            activityItems.append(image)
        } else if let imageData = design.afterImageData,
                  let image = UIImage(data: imageData) {
            activityItems.append(image)
        } else if let url = design.afterImageURL {
            fallbackURLString = url
            if let image = await loadImageFromURL(url) {
                activityItems.append(image)
            }
        }
        
        // Fallback: if image couldn't be loaded, try sharing the URL itself
        if activityItems.isEmpty, let urlString = fallbackURLString, let url = URL(string: urlString) {
            activityItems.append(url)
        }
        
        if activityItems.isEmpty {
            print("Hiçbir image ya da URL bulunamadı, share sheet açılmadı.")
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        await MainActor.run {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
                print("Share: aktif windowScene bulunamadı")
                return
            }
            guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first else {
                print("Share: window bulunamadı")
                return
            }
            guard var topVC = window.rootViewController else {
                print("Share: rootViewController yok")
                return
            }
            while let presented = topVC.presentedViewController {
                topVC = presented
            }
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = topVC.view
                popover.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            topVC.present(activityVC, animated: true)
        }
    }
}
