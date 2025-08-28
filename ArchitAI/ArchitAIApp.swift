import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

@main
struct ArchitAIApp: App {
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .system
    @StateObject private var authService = FirebaseAuthService()
    
    init() {
        // Firebase'i başlat
        if let path = Bundle.main.path(forResource: "GoogleService", ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: path) {
            FirebaseApp.configure(options: options)
        } else {
            FirebaseApp.configure()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(authService)
                .onAppear {
                    updateAppTheme(to: selectedTheme)
                }
        }
    }
    
    private func updateAppTheme(to theme: Theme) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        switch theme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        case .system:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
}
