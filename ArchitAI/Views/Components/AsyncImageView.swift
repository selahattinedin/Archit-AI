import SwiftUI

// MARK: - Async Image Loading Components

struct AsyncImageView: View {
    let url: String?
    let cache: ImageCache
    @State private var image: UIImage?
    @State private var isLoading = true
    @State private var hasError = false
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    
                    ProgressView()
                        .scaleEffect(0.8)
                }
            } else if hasError {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    
                    VStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Text("Error")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = url, !url.isEmpty else {
            isLoading = false
            hasError = true
            return
        }
        
        // Cache'den kontrol et
        if let cachedImage = cache.image(forKey: url) {
            self.image = cachedImage
            self.isLoading = false
            return
        }
        
        // URL'den yükle
        Task {
            await loadImageFromURL(url)
        }
    }
    
    @MainActor
    private func loadImageFromURL(_ urlString: String) async {
        guard let url = URL(string: urlString) else {
            isLoading = false
            hasError = true
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // HTTP response kontrolü
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                throw NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
            }
            
            if let image = UIImage(data: data) {
                // Cache'e kaydet
                cache.setImage(image, forKey: urlString)
                self.image = image
                self.hasError = false
            } else {
                throw NSError(domain: "ImageError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
            }
        } catch {
            print("Görsel yüklenemedi: \(urlString) - \(error.localizedDescription)")
            self.hasError = true
        }
        
        isLoading = false
    }
}

// MARK: - Image Cache

class ImageCache: ObservableObject {
    private let cache = NSCache<NSString, UIImage>()
    
    init() {
        cache.countLimit = 100 // Max 100 image
        cache.totalCostLimit = 50 * 1024 * 1024 // Max 50MB
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
    func removeImage(forKey key: String) {
        cache.removeObject(forKey: NSString(string: key))
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}

// MARK: - Image Loader

class AsyncImageLoader: ObservableObject {
    let cache = ImageCache()
}

