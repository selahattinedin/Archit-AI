import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class FirebaseAuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        // Mevcut kullanıcıyı dinle
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
                
                // User ID değiştiğinde notification gönder
                if let userID = user?.uid {
                    NotificationCenter.default.post(name: Notification.Name("UserIDChanged"), object: userID)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("UserIDChanged"), object: nil)
                }
            }
        }

        // Uygulama başlarken kullanıcı yoksa anonim giriş yap
        Task { [weak self] in
            guard let self = self else { return }
            let current = Auth.auth().currentUser
            if current == nil {
                await self.signInAnonymously()
            }
        }
    }
    
    // Anonymous authentication
    func signInAnonymously() async {
        print("🔐 Firebase Auth: Anonymous sign in başlatılıyor...")
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            let result = try await Auth.auth().signInAnonymously()
            DispatchQueue.main.async {
                self.currentUser = result.user
                self.isAuthenticated = true
                self.isLoading = false
                print("✅ Firebase Auth: Anonymous user başarıyla giriş yaptı - \(result.user.uid)")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("❌ Firebase Auth: Anonymous sign in hatası - \(error.localizedDescription)")
            }
        }
    }
    
    // Sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
                self.isAuthenticated = false
                print("User signed out successfully")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                print("Sign out error: \(error.localizedDescription)")
            }
        }
    }
    
    // Get current user ID
    var currentUserId: String? {
        return currentUser?.uid
    }
    
    // Check if user is anonymous
    var isAnonymous: Bool {
        return currentUser?.isAnonymous ?? false
    }
    
    // Delete account
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "FirebaseAuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user logged in"])
        }

        guard let userId = currentUserId else {
            throw NSError(domain: "FirebaseAuthService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Missing user id"])
        }

        let db = Firestore.firestore()
        let storageService = FirebaseStorageService()
        let storage = Storage.storage()

        // 1) Delete all designs for this user (Firestore + Storage images via URLs)
        do {
            let userDesigns = try await storageService.fetchUserDesigns(userID: userId)
            for design in userDesigns {
                try? await storageService.deleteDesign(design)
            }
        } catch {
            print("⚠️ DeleteAccount: fetchUserDesigns error - \(error.localizedDescription)")
        }

        // 2) Extra safety: delete designs collection docs by userId variations
        do {
            let snapshots = try await db.collection("designs").whereField("userID", isEqualTo: userId).getDocuments()
            for doc in snapshots.documents {
                try? await doc.reference.delete()
            }
        } catch {
            print("⚠️ DeleteAccount: delete designs by userID error - \(error.localizedDescription)")
        }
        do {
            let snapshots = try await db.collection("designs").whereField("userId", isEqualTo: userId).getDocuments()
            for doc in snapshots.documents {
                try? await doc.reference.delete()
            }
        } catch {
            print("⚠️ DeleteAccount: delete designs by userId error - \(error.localizedDescription)")
        }

        // 3) Delete nested users/{uid}/designs docs then user doc
        do {
            let subDesigns = try? await db.collection("users").document(userId).collection("designs").getDocuments()
            if let docs = subDesigns?.documents {
                for doc in docs { try? await doc.reference.delete() }
            }
            try? await db.collection("users").document(userId).delete()
        }

        // 4) Delete any remaining storage files under designs/{uid}/... (recursive)
        do {
            let storageServiceForDelete = FirebaseStorageService()
            await storageServiceForDelete.deleteAllUserFiles(userID: userId)
        }

        // 5) Logout from RevenueCat (if configured)
        RevenueCatService.shared.logout()

        // 6) Finally delete auth user
        try await user.delete()

        // 7) Reset local flags and immediately re-create anonymous user to keep UI functional
        UserDefaults.standard.removeObject(forKey: "didShowInitialPaywall")
        await self.signInAnonymously()
    }
}
