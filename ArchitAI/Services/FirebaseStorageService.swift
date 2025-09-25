import Foundation
import FirebaseStorage
import FirebaseFirestore
import UIKit

class FirebaseStorageService: ObservableObject {
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    // MARK: - Helper for nested document reference only
    private func nestedDesignRef(userID: String, designID: String) -> DocumentReference {
        return db.collection("users").document(userID).collection("designs").document(designID)
    }
    
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

    // MARK: - Kullanıcının tüm Storage dosyalarını sil (designs/{userId}/**)
    func deleteAllUserFiles(userID: String) async {
        let rootRef = storage.reference().child("designs/\(userID)")
        await deleteRecursively(reference: rootRef)
    }

    // Recursively delete all files and subfolders under a reference
    private func deleteRecursively(reference: StorageReference) async {
        do {
            let result = try await listAllAsync(reference: reference)
            // Delete all items (files)
            for item in result.items {
                do {
                    try await item.delete()
                    print("✅ Firebase Storage: Silindi -> \(item.fullPath)")
                } catch {
                    print("⚠️ Firebase Storage: Silinemedi -> \(item.fullPath) - \(error.localizedDescription)")
                }
            }
            // Recurse into prefixes (folders)
            for prefix in result.prefixes {
                await deleteRecursively(reference: prefix)
            }
        } catch {
            print("⚠️ Firebase Storage: listAll hatası -> \(reference.fullPath) - \(error.localizedDescription)")
        }
    }

    // Async wrapper for listAll
    private func listAllAsync(reference: StorageReference) async throws -> StorageListResult {
        try await withCheckedThrowingContinuation { continuation in
            reference.listAll { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result {
                    continuation.resume(returning: result)
                } else {
                    continuation.resume(throwing: NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown listAll error"]))
                }
            }
        }
    }
    
    // Design'ı Firestore'a kaydetme (yalnızca nested path)
    func saveDesign(_ design: Design, userID: String) async throws {
        print("📝 Firestore: Design kaydediliyor - \(design.id.uuidString)")
        print("📝 Firestore: Design title - \(design.title)")
        print("📝 Firestore: Design userID - \(design.userID ?? "nil")")
        print("📝 Firestore: Target userID - \(userID)")
        
        let designData: [String: Any] = [
            "id": design.id.uuidString,
            "title": design.title,
            "style": [
                "name": design.style.name, // Bu zaten localization key
                "description": design.style.description, // Bu zaten localization key
                "image": design.style.image,
                "tags": design.style.tags
            ],
            "room": [
                "name": design.room.name, // Bu zaten localization key
                "icon": design.room.icon,
                "description": design.room.description // Bu zaten localization key
            ],
            "beforeImageURL": design.beforeImageURL ?? "",
            "afterImageURL": design.afterImageURL ?? "",
            "userID": userID,
            "createdAt": design.createdAt,
            "updatedAt": Date()
        ]
        
        print("📊 Firestore: Design data hazırlandı")
        print("📊 Firestore: userID field - \(designData["userID"] ?? "nil")")
        
        try await nestedDesignRef(userID: userID, designID: design.id.uuidString).setData(designData)
        print("✅ Firestore: Design başarıyla kaydedildi (nested) - Document ID: \(design.id.uuidString)")
    }
    
    // Design'ı Firestore'dan silme (yalnızca nested)
    func deleteDesign(_ design: Design) async throws {
        print("🗑️ Firebase: Design siliniyor - \(design.id.uuidString)")
        
        if let userID = design.userID {
            try? await nestedDesignRef(userID: userID, designID: design.id.uuidString).delete()
        }
        print("✅ Firestore: Design silindi (nested)")
        
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
    
    // Kullanıcının tüm design'larını getirme - Yalnızca nested path
    func fetchUserDesigns(userID: String) async throws -> [Design] {
        print("🔍 Firestore: Designs aranıyor - UserID: \(userID)")
        
        do {
            print("🔍 Firestore: Nested path sorgulanıyor users/\(userID)/designs")
            let subSnap = try await db.collection("users").document(userID).collection("designs").order(by: "createdAt", descending: true).getDocuments()
            var designs: [Design] = []
            for document in subSnap.documents {
                do {
                    let design = try parseDesignFromDocument(document)
                    designs.append(design)
                } catch {
                    print("⚠️ Firestore: Nested parse edilemedi - \(document.documentID) - Hata: \(error)")
                }
            }
            print("✅ Firestore: \(designs.count) design başarıyla yüklendi ve sıralandı")
            return designs.sorted { $0.createdAt > $1.createdAt }
            
        } catch {
            print("❌ Firestore: Query hatası - \(error.localizedDescription)")
            throw error
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
        
        // Stil için localization key'lerini bul
        let styleName = styleData["name"] as? String ?? ""
        let styleDesc = styleData["description"] as? String ?? ""
        
        // Eğer direkt string ise (eski veri), localization key'ine çevir
        let styleNameKey = styleName.starts(with: "style_") ? styleName : "style_\(styleName.lowercased().replacingOccurrences(of: " ", with: "_"))"
        let styleDescKey = styleDesc.starts(with: "style_") ? styleDesc : "style_\(styleName.lowercased().replacingOccurrences(of: " ", with: "_"))_desc"
        
        let style = DesignStyle(
            name: styleNameKey,
            description: styleDescKey,
            image: styleData["image"] as? String ?? "photo",
            tags: styleData["tags"] as? [String] ?? []
        )
        
        // Oda için localization key'lerini bul
        let roomName = roomData["name"] as? String ?? ""
        let roomDesc = roomData["description"] as? String ?? ""
        
        // Eğer direkt string ise (eski veri), localization key'ine çevir
        let roomNameKey = roomName.starts(with: "room_") ? roomName : "room_\(roomName.lowercased().replacingOccurrences(of: " ", with: "_"))"
        let roomDescKey = roomDesc.starts(with: "room_") ? roomDesc : "room_\(roomName.lowercased().replacingOccurrences(of: " ", with: "_"))_desc"
        
        let room = Room(
            name: roomNameKey,
            icon: roomData["icon"] as? String ?? "photo",
            description: roomDescKey,
            category: RoomCategory(rawValue: roomData["category"] as? String ?? "living") ?? .living,
            gradientColors: roomData["gradientColors"] as? [String] ?? []
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
    
    // Design'ı güncelleme (yalnızca nested)
    func updateDesign(_ design: Design) async throws {
        print("📝 Firestore: Design güncelleniyor - \(design.id.uuidString)")
        
        let designData: [String: Any] = [
            "title": design.title,
            "updatedAt": Date()
        ]
        
        if let userID = design.userID {
            try? await nestedDesignRef(userID: userID, designID: design.id.uuidString).updateData(designData)
        }
        print("✅ Firestore: Design başarıyla güncellendi (nested)")
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
