import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isShowingPhotoUpload = false {
        didSet {
            if isShowingPhotoUpload {
                NotificationCenter.default.post(name: Notification.Name("SwitchToCreateTab"), object: nil)
            }
        }
    }
    @Published var isShowingSettings = false
    @Published var designs: [Design] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let storageService = FirebaseStorageService()
    private let userDefaults = UserDefaults.standard
    private let designsKey = "savedDesigns"
    
    // Firebase user ID için key
    private var userSpecificKey: String {
        // Eğer user ID varsa ona özel key kullan, yoksa genel key
        if let userID = currentUserID {
            return "savedDesigns_\(userID)"
        }
        return "savedDesigns"
    }
    
    // Current user ID'yi sakla
    private var currentUserID: String?
    
    init() {
        loadDesigns()
    }
    
    func showSettings() {
        isShowingSettings = true
    }
    
    func addDesign(_ design: Design) {
        designs.insert(design, at: 0) // En yeni tasarım en üstte
        
        // Local storage'a kaydet
        saveDesigns()
        
        // Firebase'e kaydet
        if let userID = currentUserID {
            Task {
                await saveDesignToFirebase(design: design, userID: userID)
            }
        }
    }
    
    // Firebase'e design kaydetme
    @MainActor
    func saveDesignToFirebase(design: Design, userID: String) async {
        print("🚀 HomeViewModel: Firebase'e design kaydediliyor...")
        
        do {
            // Resimleri Firebase Storage'a yükle
            let beforeImagePath = "designs/\(userID)/\(design.id.uuidString)/before.jpg"
            let afterImagePath = "designs/\(userID)/\(design.id.uuidString)/after.jpg"
            
            print("📤 HomeViewModel: Before image yükleniyor - \(beforeImagePath)")
            guard let beforeImageData = design.beforeImageData,
                  let beforeImage = UIImage(data: beforeImageData) else {
                throw NSError(domain: "DesignError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Before image data is missing"])
            }
            let beforeImageURL = try await storageService.uploadImage(beforeImage, path: beforeImagePath)
            
            print("📤 HomeViewModel: After image yükleniyor - \(afterImagePath)")
            guard let afterImageData = design.afterImageData,
                  let afterImage = UIImage(data: afterImageData) else {
                throw NSError(domain: "DesignError", code: 2, userInfo: [NSLocalizedDescriptionKey: "After image data is missing"])
            }
            let afterImageURL = try await storageService.uploadImage(afterImage, path: afterImagePath)
            
            // Design'ı güncelle - URL'leri ekle
            let updatedDesign = Design(
                id: design.id,
                title: design.title,
                style: design.style,
                room: design.room,
                beforeImageURL: beforeImageURL,
                afterImageURL: afterImageURL,
                userID: userID,
                createdAt: design.createdAt
            )
            
            print("💾 HomeViewModel: Design Firestore'a kaydediliyor...")
            // Design'ı Firestore'a kaydet
            try await storageService.saveDesign(updatedDesign, userID: userID)
            
            print("✅ HomeViewModel: Design Firebase'e başarıyla kaydedildi")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ HomeViewModel: Design Firebase'e kaydedilirken hata - \(error.localizedDescription)")
        }
    }
    
    func removeDesign(_ design: Design) {
        designs.removeAll { $0.id == design.id }
        
        // Local storage'dan sil
        saveDesigns()
        
        // Firebase'den sil
        Task {
            await deleteDesignFromFirebase(design: design)
        }
    }
    
    // Firebase'den design silme
    @MainActor
    func deleteDesignFromFirebase(design: Design) async {
        do {
            try await storageService.deleteDesign(design)
            print("Design Firebase'den başarıyla silindi")
        } catch {
            errorMessage = error.localizedDescription
            print("Design Firebase'den silinirken hata: \(error.localizedDescription)")
        }
    }
    
    func loadDesigns() {
        guard let data = userDefaults.data(forKey: userSpecificKey),
              let decodedDesigns = try? JSONDecoder().decode([Design].self, from: data) else {
            return
        }
        designs = decodedDesigns
    }
    
    private func saveDesigns() {
        guard let encodedData = try? JSONEncoder().encode(designs) else { return }
        userDefaults.set(encodedData, forKey: userSpecificKey)
    }
    
    // Firebase user ID'yi set et
    func setUserID(_ userID: String?) {
        // User ID değiştiğinde designs'ı yeniden yükle
        currentUserID = userID
        designs = [] // Önce mevcut designs'ı temizle
        
        if let userID = userID {
            // Firebase'den designs'ı yükle
            Task {
                await loadDesignsFromFirebase(userID: userID)
            }
        } else {
            // Local storage'dan yükle
            loadDesigns()
        }
    }
    
    // Firebase'den designs yükleme
    @MainActor
    func loadDesignsFromFirebase(userID: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let firebaseDesigns = try await storageService.fetchUserDesigns(userID: userID)
            designs = firebaseDesigns
            isLoading = false
        } catch {
            // Index hatası için özel mesaj
            if error.localizedDescription.contains("index") {
                errorMessage = "Firebase index oluşturuluyor, lütfen birkaç dakika bekleyin..."
            } else {
                errorMessage = error.localizedDescription
            }
            isLoading = false
            print("Firebase'den designs yüklenirken hata: \(error.localizedDescription)")
        }
    }
}