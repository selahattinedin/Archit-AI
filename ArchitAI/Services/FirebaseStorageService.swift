import Foundation
import FirebaseStorage
import FirebaseFirestore
import UIKit

class FirebaseStorageService: ObservableObject {
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    // Resim yükleme
    func uploadImage(_ image: UIImage, path: String) async throws -> String {
        print("🖼️ Firebase Storage: Resim yükleniyor - \(path)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ Firebase Storage: Resim sıkıştırılamadı")
            throw StorageError.compressionFailed
        }
        
        let storageRef = storage.reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        print("📤 Firebase Storage: Resim yükleniyor...")
        let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
        print("✅ Firebase Storage: Resim yüklendi")
        
        let downloadURL = try await storageRef.downloadURL()
        print("🔗 Firebase Storage: Download URL alındı - \(downloadURL.absoluteString)")
        
        return downloadURL.absoluteString
    }
    
    // Resim URL'den yükleme (cache ile)
    func loadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            print("❌ Firebase Storage: Geçersiz URL - \(urlString)")
            return nil
        }
        
        do {
            print("📥 Firebase Storage: Resim indiriliyor - \(urlString)")
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                print("✅ Firebase Storage: Resim başarıyla indirildi")
                return image
            } else {
                print("❌ Firebase Storage: Resim data'sı UIImage'a çevrilemedi")
                return nil
            }
        } catch {
            print("❌ Firebase Storage: Resim indirme hatası - \(error.localizedDescription)")
            return nil
        }
    }
    
    // Resim silme
    func deleteImage(path: String) async throws {
        print("🗑️ Firebase Storage: Resim siliniyor - \(path)")
        
        let storageRef = storage.reference().child(path)
        try await storageRef.delete()
        
        print("✅ Firebase Storage: Resim başarıyla silindi - \(path)")
    }
    
    // Design'ı Firestore'a kaydetme
    func saveDesign(_ design: Design, userID: String) async throws {
        print("📝 Firestore: Design kaydediliyor - \(design.id.uuidString)")
        
        let designData: [String: Any] = [
            "id": design.id.uuidString,
            "title": design.title,
            "style": [
                "name": design.style.name,
                "description": design.style.description,
                "image": design.style.image,
                "tags": design.style.tags
            ],
            "room": [
                "name": design.room.name,
                "icon": design.room.icon,
                "description": design.room.description
            ],
            "beforeImageURL": design.beforeImageURL ?? "",
            "afterImageURL": design.afterImageURL ?? "",
            "userID": userID,
            "createdAt": design.createdAt,
            "updatedAt": Date()
        ]
        
        print("📊 Firestore: Design data hazırlandı")
        try await db.collection("designs").document(design.id.uuidString).setData(designData)
        print("✅ Firestore: Design başarıyla kaydedildi")
    }
    
    // Design'ı Firestore'dan silme
    func deleteDesign(_ design: Design) async throws {
        print("🗑️ Firebase: Design siliniyor - \(design.id.uuidString)")
        
        // Firestore'dan sil
        try await db.collection("designs").document(design.id.uuidString).delete()
        print("✅ Firestore: Design silindi")
        
        // Storage'dan resimleri sil - URL'den path çıkar
        if let beforeImageURL = design.beforeImageURL, !beforeImageURL.isEmpty {
            let path = extractPathFromURL(beforeImageURL)
            print("🗑️ Firebase Storage: Before image siliniyor - \(path)")
            try? await deleteImage(path: path) // Try kullan, hata durumunda devam et
        }
        if let afterImageURL = design.afterImageURL, !afterImageURL.isEmpty {
            let path = extractPathFromURL(afterImageURL)
            print("🗑️ Firebase Storage: After image siliniyor - \(path)")
            try? await deleteImage(path: path) // Try kullan, hata durumunda devam et
        }
        
        print("✅ Firebase: Design ve resimler başarıyla silindi")
    }
    
    // URL'den storage path çıkarma - İyileştirilmiş
    private func extractPathFromURL(_ url: String) -> String {
        print("🔗 Firebase Storage: URL'den path çıkarılıyor - \(url)")
        
        // Firebase Storage URL formatı:
        // https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{path}?{params}
        
        // URL'i ayrıştır
        guard let urlComponents = URLComponents(string: url),
              let pathComponent = urlComponents.path.split(separator: "/").last else {
            print("⚠️ Firebase Storage: URL ayrıştırılamadı, orijinal URL kullanılıyor")
            return url
        }
        
        // Percent encoding'i kaldır
        let decodedPath = String(pathComponent).removingPercentEncoding ?? String(pathComponent)
        
        print("🔗 Firebase Storage: Path çıkarıldı - \(decodedPath)")
        return decodedPath
    }
    
    // Kullanıcının tüm design'larını getirme - İyileştirilmiş
    func fetchUserDesigns(userID: String) async throws -> [Design] {
        print("🔍 Firestore: Designs aranıyor - UserID: \(userID)")
        
        do {
            // Firebase query ile designs'ları getir
            let snapshot = try await db.collection("designs")
                .whereField("userID", isEqualTo: userID)
                .order(by: "createdAt", descending: true) // En yeni önce
                .limit(to: 50) // Performans için limit
                .getDocuments()
            
            print("📄 Firestore: \(snapshot.documents.count) design bulundu")
            
            var designs: [Design] = []
            
            for document in snapshot.documents {
                do {
                    let design = try parseDesignFromDocument(document)
                    designs.append(design)
                } catch {
                    print("⚠️ Firestore: Design parse edilemedi - \(document.documentID) - Hata: \(error)")
                    continue // Bu design'ı atla, diğerlerine devam et
                }
            }
            
            print("✅ Firestore: \(designs.count) design başarıyla yüklendi")
            return designs
            
        } catch {
            // Index hatası için özel handling
            if error.localizedDescription.contains("index") ||
               error.localizedDescription.contains("FAILED_PRECONDITION") {
                print("⚠️ Firestore Index hatası, basit query deneniyor...")
                
                // Fallback: Index olmadan sadece userID ile filtrele
                let snapshot = try await db.collection("designs")
                    .whereField("userID", isEqualTo: userID)
                    .getDocuments()
                
                var designs: [Design] = []
                
                for document in snapshot.documents {
                    do {
                        let design = try parseDesignFromDocument(document)
                        designs.append(design)
                    } catch {
                        continue
                    }
                }
                
                // Client-side sorting
                designs.sort { $0.createdAt > $1.createdAt }
                
                print("✅ Firestore Fallback: \(designs.count) design yüklendi ve sıralandı")
                return designs
                
            } else {
                throw error
            }
        }
    }
    
    // Document'tan Design parse etme - Helper function
    private func parseDesignFromDocument(_ document: QueryDocumentSnapshot) throws -> Design {
        let data = document.data()
        
        // Zorunlu alanları kontrol et
        guard let idString = data["id"] as? String,
              let uuid = UUID(uuidString: idString),
              let title = data["title"] as? String,
              let userID = data["userID"] as? String else {
            throw ParseError.missingRequiredFields
        }
        
        // Style ve Room objelerini oluştur
        let styleData = data["style"] as? [String: Any] ?? [:]
        let roomData = data["room"] as? [String: Any] ?? [:]
        
        let style = DesignStyle(
            name: styleData["name"] as? String ?? "",
            description: styleData["description"] as? String ?? "",
            image: styleData["image"] as? String ?? "photo",
            tags: styleData["tags"] as? [String] ?? []
        )
        
        let room = Room(
            name: roomData["name"] as? String ?? "",
            icon: roomData["icon"] as? String ?? "photo",
            description: roomData["description"] as? String ?? ""
        )
        
        // Tarih conversion
        let createdAt: Date
        if let timestamp = data["createdAt"] as? Timestamp {
            createdAt = timestamp.dateValue()
        } else if let dateString = data["createdAt"] as? String {
            // String date fallback
            let formatter = ISO8601DateFormatter()
            createdAt = formatter.date(from: dateString) ?? Date()
        } else {
            createdAt = Date()
        }
        
        // Design objesini oluştur
        let design = Design(
            id: uuid,
            title: title,
            style: style,
            room: room,
            beforeImageURL: {
                let val = data["beforeImageURL"] as? String
                return (val?.isEmpty == true) ? nil : val
            }(),
            afterImageURL: {
                let val = data["afterImageURL"] as? String
                return (val?.isEmpty == true) ? nil : val
            }(),
            userID: userID,
            createdAt: createdAt
        )
        
        return design
    }
    
    // Design'ı güncelleme
    func updateDesign(_ design: Design) async throws {
        print("📝 Firestore: Design güncelleniyor - \(design.id.uuidString)")
        
        let designData: [String: Any] = [
            "title": design.title,
            "updatedAt": Date()
        ]
        
        try await db.collection("designs").document(design.id.uuidString).updateData(designData)
        print("✅ Firestore: Design başarıyla güncellendi")
    }
}

// MARK: - Errors
enum StorageError: Error, LocalizedError {
    case compressionFailed
    case uploadFailed
    case downloadFailed
    
    var errorDescription: String? {
        switch self {
        case .compressionFailed:
            return "Resim sıkıştırılamadı"
        case .uploadFailed:
            return "Resim yüklenemedi"
        case .downloadFailed:
            return "Resim indirilemedi"
        }
    }
}

enum ParseError: Error, LocalizedError {
    case missingRequiredFields
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .missingRequiredFields:
            return "Gerekli alanlar eksik"
        case .invalidData:
            return "Geçersiz veri formatı"
        }
    }
}
