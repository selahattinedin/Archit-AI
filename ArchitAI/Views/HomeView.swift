import SwiftUI

struct HomeView: View {
    @StateObject private var languageManager = LanguageManager.shared
    
    private var iPadContent: some View {
        let designCards = [
            (id: UUID(), title: "room_design_title".localized(with: languageManager.languageUpdateTrigger),
             subtitle: "room_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
             beforeImage: "old_room",
             afterImage: "new_room"),
            (id: UUID(), title: "bedroom_design_title".localized(with: languageManager.languageUpdateTrigger),
             subtitle: "bedroom_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
             beforeImage: "old_bedroom",
             afterImage: "new_bedroom"),
            (id: UUID(), title: "balcony_design_title".localized(with: languageManager.languageUpdateTrigger),
             subtitle: "balcony_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
             beforeImage: "old_balcony",
             afterImage: "new_balcony"),
            (id: UUID(), title: "garden_design_title".localized(with: languageManager.languageUpdateTrigger),
             subtitle: "garden_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
             beforeImage: "old_garden",
             afterImage: "new_garden"),
            (id: UUID(), title: "bathroom_design_title".localized(with: languageManager.languageUpdateTrigger),
             subtitle: "bathroom_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
             beforeImage: "old_bathroom",
             afterImage: "new_bathroom")
        ]
        
        return LazyVStack(spacing: 30) {
            ForEach(designCards, id: \.id) { card in
                DesignOptionCard(
                    title: card.title,
                    subtitle: card.subtitle,
                    beforeImage: card.beforeImage,
                    afterImage: card.afterImage
                ) {
                    if purchases.isPro {
                        viewModel.isShowingPhotoUpload = true
                    } else {
                        showPaywall = true
                    }
                }
            }
        }
        .padding(.horizontal, 40)
        .padding(.top, 10)
    }
    
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var authService: FirebaseAuthService
    @EnvironmentObject var purchases: RevenueCatService
    @State private var selectedTab = 0
    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var scrollOffset: CGFloat = 0
    @State private var refreshID = UUID() // View'ı yenilemek için
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        NavigationView {
            Group {
                if horizontalSizeClass == .regular && isIPad {
                    // iPad Layout
                    ZStack {
                        // Background
                        (colorScheme == .dark ? Color.black : Color.white)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 0) {
                            // iPad Header Layout
                            HStack {
                                // Premium Button
                                HStack {
                                    Button {
                                        showPaywall = true
                                    } label: {
                                        ProBadgeView()
                                            .scaleEffect(1.2)
                                    }
                                    .accessibilityLabel("upgrade_to_premium".localized(with: languageManager.languageUpdateTrigger))
                                    .contentShape(Rectangle())
                                }
                                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 120, height: 44)
                                
                                Spacer()
                                
                                // Title
                                Text("archit_ai".localized(with: languageManager.languageUpdateTrigger))
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                
                                Spacer()
                                
                                // Settings Button
                                HStack {
                                    Button {
                                        showSettings = true
                                    } label: {
                                        Image(systemName: "gearshape.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(Constants.Colors.textPrimary)
                                    }
                                    .accessibilityLabel("settings".localized(with: languageManager.languageUpdateTrigger))
                                    .contentShape(Rectangle())
                                }
                                .frame(width: 120, height: 44)
                            }
                            .padding(.horizontal, 40)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                            
                            // Scrollable Content
                            ScrollView(showsIndicators: false) {
                                iPadContent
                            }
                        }
                    }
                } else {
                    // iPhone Layout
                    VStack(spacing: 0) {
                        // iPhone Header Layout
                        VStack(spacing: 20) {
                            HStack {
                                Button(action: {
                                    showPaywall.toggle()
                                }) {
                                    ProBadgeView()
                                }
                                .accessibilityLabel("upgrade_to_premium".localized(with: languageManager.languageUpdateTrigger))
                                .buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                                
                                Button(action: {
                                    showSettings.toggle()
                                }) {
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(Constants.Colors.textPrimary)
                                }
                                .accessibilityLabel("settings".localized(with: languageManager.languageUpdateTrigger))
                                .buttonStyle(PlainButtonStyle())
                            }
                            .overlay(
                                Text("archit_ai".localized(with: languageManager.languageUpdateTrigger))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            )
                            .padding(.top, 16)
                        }
                        .background(.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .padding(.horizontal, 20)
                        
                        ScrollView(showsIndicators: false) {
                            let designCards = [
                                (id: UUID(), title: "room_design_title".localized(with: languageManager.languageUpdateTrigger),
                                 subtitle: "room_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
                                 beforeImage: "old_room",
                                 afterImage: "new_room"),
                                (id: UUID(), title: "bedroom_design_title".localized(with: languageManager.languageUpdateTrigger),
                                 subtitle: "bedroom_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
                                 beforeImage: "old_bedroom",
                                 afterImage: "new_bedroom"),
                                (id: UUID(), title: "balcony_design_title".localized(with: languageManager.languageUpdateTrigger),
                                 subtitle: "balcony_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
                                 beforeImage: "old_balcony",
                                 afterImage: "new_balcony"),
                                (id: UUID(), title: "garden_design_title".localized(with: languageManager.languageUpdateTrigger),
                                 subtitle: "garden_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
                                 beforeImage: "old_garden",
                                 afterImage: "new_garden"),
                                (id: UUID(), title: "bathroom_design_title".localized(with: languageManager.languageUpdateTrigger),
                                 subtitle: "bathroom_design_subtitle".localized(with: languageManager.languageUpdateTrigger),
                                 beforeImage: "old_bathroom",
                                 afterImage: "new_bathroom")
                            ]
                            
                            LazyVStack(spacing: 25) {
                                ForEach(designCards, id: \.id) { card in
                                    DesignOptionCard(
                                        title: card.title,
                                        subtitle: card.subtitle,
                                        beforeImage: card.beforeImage,
                                        afterImage: card.afterImage
                                    ) {
                                        if purchases.isPro {
                                            viewModel.isShowingPhotoUpload = true
                                        } else {
                                            showPaywall = true
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 30)
                            
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 50)
                        }
                    }
                    .background(colorScheme == .dark ? Color.black : Color.white)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(purchasesService: purchases)
                .onDisappear {
                    print("🟠 HomeView: Paywall disappeared, showPaywall: \(showPaywall)")
                }
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(authService)
        }
        .onAppear {
            // View yüklendiğinde anonymous authentication yap
            if !authService.isAuthenticated {
                Task {
                    await authService.signInAnonymously()
                }
            }
        }
        .onChange(of: authService.currentUserId) { userID in
            // User ID değiştiğinde HomeViewModel'i güncelle
            viewModel.setUserID(userID)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            // Dil değiştiğinde view'ı yeniden yükle
            refreshID = UUID()
        }
        .id(refreshID) // View'ı yenilemek için
    }
}