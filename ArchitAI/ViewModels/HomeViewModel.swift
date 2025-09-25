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
    @Published var isSaving = false
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
        print("💾 HomeViewModel: Design ekleniyor - \(design.title)")
        print("💾 HomeViewModel: Mevcut designs sayısı: \(designs.count)")
        print("💾 HomeViewModel: Current userID: \(currentUserID ?? "nil")")
        print("💾 HomeViewModel: Design userID: \(design.userID ?? "nil")")
        
        designs.insert(design, at: 0) // En yeni tasarım en üstte
        
        print("💾 HomeViewModel: Design eklendi - Yeni designs sayısı: \(designs.count)")
        
        // Local storage'a kaydet
        saveDesigns()
        
        // Firebase'e kaydet - her zaman design'daki userID'yi kullan
        if let userID = design.userID {
            print("💾 HomeViewModel: Firebase'e kaydediliyor - UserID: \(userID)")
            Task {
                await saveDesignToFirebase(design: design, userID: userID)
            }
        } else {
            print("⚠️ HomeViewModel: Design'da userID yok, Firebase'e kaydedilemiyor")
        }
    }
    
    // Firebase'e design kaydetme
    @MainActor
    func saveDesignToFirebase(design: Design, userID: String) async {
        print("🚀 HomeViewModel: Firebase'e design kaydediliyor...")
        print("🚀 HomeViewModel: Design ID: \(design.id.uuidString)")
        print("🚀 HomeViewModel: Design Title: \(design.title)")
        print("🚀 HomeViewModel: Design UserID: \(design.userID ?? "nil")")
        print("🚀 HomeViewModel: Target UserID: \(userID)")
        
        isSaving = true
        
        do {
            // Resimleri Firebase Storage'a yükle
            let beforeImagePath = "designs/\(userID)/\(design.id.uuidString)/before.jpg"
            let afterImagePath = "designs/\(userID)/\(design.id.uuidString)/after.jpg"
            
            print("📤 HomeViewModel: Before image yükleniyor - \(beforeImagePath)")
            guard let beforeImageData = design.beforeImageData,
                  let beforeImage = UIImage(data: beforeImageData) else {
                print("❌ HomeViewModel: Before image data eksik")
                throw NSError(domain: "DesignError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Before image data is missing"])
            }
            let beforeImageURL = try await storageService.uploadImage(beforeImage, path: beforeImagePath)
            print("✅ HomeViewModel: Before image yüklendi - \(beforeImageURL)")
            
            print("📤 HomeViewModel: After image yükleniyor - \(afterImagePath)")
            guard let afterImageData = design.afterImageData,
                  let afterImage = UIImage(data: afterImageData) else {
                print("❌ HomeViewModel: After image data eksik")
                throw NSError(domain: "DesignError", code: 2, userInfo: [NSLocalizedDescriptionKey: "After image data is missing"])
            }
            let afterImageURL = try await storageService.uploadImage(afterImage, path: afterImagePath)
            print("✅ HomeViewModel: After image yüklendi - \(afterImageURL)")
            
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
            print("💾 HomeViewModel: Updated Design UserID: \(updatedDesign.userID ?? "nil")")
            // Design'ı Firestore'a kaydet
            try await storageService.saveDesign(updatedDesign, userID: userID)
            
            print("✅ HomeViewModel: Design Firebase'e başarıyla kaydedildi")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ HomeViewModel: Design Firebase'e kaydedilirken hata - \(error.localizedDescription)")
        }
        
        isSaving = false
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
        print("💾 HomeViewModel: Local designs yükleniyor...")
        print("💾 HomeViewModel: User specific key: \(userSpecificKey)")
        
        guard let data = userDefaults.data(forKey: userSpecificKey),
              let decodedDesigns = try? JSONDecoder().decode([Design].self, from: data) else {
            print("💾 HomeViewModel: Local designs bulunamadı veya decode edilemedi")
            return
        }
        
        designs = decodedDesigns
        print("💾 HomeViewModel: Local designs yüklendi - count: \(designs.count)")
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
            
            // Eğer Firebase'den design geliyorsa, onları kullan
            if !firebaseDesigns.isEmpty {
                designs = firebaseDesigns
                print("💾 HomeViewModel: Firebase'den \(firebaseDesigns.count) design yüklendi")
            } else {
                // Firebase'den design gelmiyorsa, local designs'ı koru
                print("💾 HomeViewModel: Firebase'den design gelmedi, local designs korunuyor - count: \(designs.count)")
            }
            
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