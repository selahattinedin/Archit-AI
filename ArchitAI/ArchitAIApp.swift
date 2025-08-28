import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import RevenueCat

@main
struct ArchitAIApp: App {
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .system
    @StateObject private var authService = FirebaseAuthService()
    @StateObject private var purchases = RevenueCatService.shared
    @State private var showLaunchPaywall = true
    
    init() {
        // Firebase'i başlat
        if let path = Bundle.main.path(forResource: "GoogleService", ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: path) {
            FirebaseApp.configure(options: options)
        } else {
            FirebaseApp.configure()
        }

        // RevenueCat yapılandırması
        RevenueCatService.shared.configure(apiKey: "appl_RxSWuInldKmQzaJMcCooqPsZJEo")
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(authService)
                .environmentObject(purchases)
                .fullScreenCover(isPresented: $showLaunchPaywall) {
                    PaywallView(purchasesService: purchases)
                }
                .onAppear {
                    updateAppTheme(to: selectedTheme)
                    // Kullanıcı kimliği varsa RevenueCat'e ilet
                    if let uid = authService.currentUserId {
                        RevenueCatService.shared.identify(userId: uid)
                    }
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
