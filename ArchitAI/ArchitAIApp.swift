import SwiftUI
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import FirebaseAuth
import RevenueCat

@main
struct ArchitAIApp: App {
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .system
    @StateObject private var authService = FirebaseAuthService()
    @StateObject private var purchases = RevenueCatService.shared
    @StateObject private var languageManager = LanguageManager.shared
    @State private var showLaunchPaywall = false
    
    init() {
        // Firebase'i başlat (yalnızca gerçek Firebase)
        if let path = Bundle.main.path(forResource: "GoogleService", ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: path) {
            FirebaseApp.configure(options: options)
        } else {
            FirebaseApp.configure()
        }

        // Emülatör bağlantıları kaldırıldı – her zaman prod Firebase'e bağlanır

        // RevenueCat yapılandırması - API anahtarı Config.plist'ten okunur
        let revenueCatAPIKey = getRevenueCatAPIKey()
        RevenueCatService.shared.configure(apiKey: revenueCatAPIKey)
        
        // Dil ayarlarını başlangıçta yükle
        setupInitialLanguage()
    }
    
    private func getRevenueCatAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let apiKey = plist["REVENUECAT_API_KEY"] as? String else {
            fatalError("REVENUECAT_API_KEY not found in Config.plist")
        }
        return apiKey
    }
    
    private func setupInitialLanguage() {
        if let languageCode = UserDefaults.standard.string(forKey: "app_language") {
            Bundle.setLanguage(languageCode)
        } else {
            // Sistem dilini kontrol et
            let systemLanguage = Locale.current.languageCode ?? "en"
            let appLanguage = AppLanguage(rawValue: systemLanguage) ?? .english
            UserDefaults.standard.set(appLanguage.rawValue, forKey: "app_language")
            Bundle.setLanguage(appLanguage.rawValue)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(authService)
                .environmentObject(purchases)
                .environmentObject(languageManager)
                .onAppear {
                    updateAppTheme(to: selectedTheme)
                    // Kullanıcı kimliği varsa RevenueCat'e ilet
                    if let uid = authService.currentUserId {
                        RevenueCatService.shared.identify(userId: uid)
                    }
                }
                // Dil değişikliklerini dinle ve UI'ı güncelle
                .onReceive(languageManager.$languageUpdateTrigger) { _ in
                    // UI'ın tamamen yeniden render edilmesini sağla
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

    // Emülatör/konfig yardımcıları kaldırıldı
}
