import SwiftUI

struct MainTabView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var createViewModel: CreateDesignViewModel
    @EnvironmentObject var authService: FirebaseAuthService
    @EnvironmentObject var purchases: RevenueCatService
    @State private var selectedTab = 0
    @State private var viewRefreshTrigger = false
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var languageManager = LanguageManager.shared
    
    init() {
        let homeVM = HomeViewModel()
        _homeViewModel = StateObject(wrappedValue: homeVM)
        _createViewModel = StateObject(wrappedValue: CreateDesignViewModel(onComplete: { design in
            print("💾 MainTabView: onComplete çağrıldı - \(design.title)")
            homeVM.addDesign(design)
            print("💾 MainTabView: Design eklendi - \(design.title)")
            print("💾 MainTabView: Mevcut designs count: \(homeVM.designs.count)")
        }))
        

        
        // Tab bar görünümünü özelleştir
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Tab bar arka planını transparan yap
        appearance.backgroundColor = .clear
        
        // Blur efekti ekle
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
        
        // Normal durum renkleri
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                .white.withAlphaComponent(0.6) : // Dark mode'da soluk beyaz
                .black.withAlphaComponent(0.6)   // Light mode'da soluk siyah
        }
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? 
                    UIColor.white.withAlphaComponent(0.6) : // Dark mode'da soluk beyaz
                    UIColor.black.withAlphaComponent(0.6)   // Light mode'da soluk siyah
            }
        ]
        
        // Seçili durum renkleri
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? 
                .white : // Dark mode'da beyaz
                .black  // Light mode'da siyah
        }
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? 
                    UIColor.white : // Dark mode'da beyaz
                    UIColor.black   // Light mode'da siyah
            }
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Tab bar'ı biraz aşağı kaydır
        UITabBar.appearance().frame.origin.y += 10
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(homeViewModel)
                .environmentObject(authService)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("home".localized(with: languageManager.languageUpdateTrigger))
                }
                .tag(0)
            
            CreateView(viewModel: createViewModel, tabBarHidden: .constant(false))
                .environmentObject(authService)
                .environmentObject(homeViewModel)
                .environmentObject(purchases)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("create".localized(with: languageManager.languageUpdateTrigger))
                }
                .tag(1)
            
            HistoryView()
                .environmentObject(homeViewModel)
                .environmentObject(authService)
            .tabItem {
                Image(systemName: "clock.fill")
                Text("history".localized(with: languageManager.languageUpdateTrigger))
            }
            .tag(2)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SwitchToHistoryTab"))) { _ in
            withAnimation {
                selectedTab = 2
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SwitchToCreateTab"))) { _ in
            withAnimation {
                selectedTab = 1
            }
        }
        // Create tab'da kal; premium kontrolünü sadece Transform aşamasında yapacağız
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("UserIDChanged"))) { notification in
            if let userID = notification.object as? String {
                homeViewModel.setUserID(userID)
            } else {
                homeViewModel.setUserID(nil)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("LanguageChanged"))) { _ in
            // Force view refresh
            viewRefreshTrigger.toggle()
        }
    }
}

#Preview {
    MainTabView()
}