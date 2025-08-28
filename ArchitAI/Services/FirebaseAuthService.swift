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
}
