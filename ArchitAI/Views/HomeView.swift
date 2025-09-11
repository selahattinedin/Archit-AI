import SwiftUI

struct HomeView: View {
    private var iPadContent: some View {
        let designCards = [
            (title: "Room Design",
             subtitle: "Upload a pic, choose a style, let AI design the room!",
             beforeImage: "old_room",
             afterImage: "new_room"),
            (title: "Bedroom Design",
             subtitle: "Transform your bedroom into a cozy and stylish space!",
             beforeImage: "old_bedroom",
             afterImage: "new_bedroom"),
            (title: "Balcony Design",
             subtitle: "Transform your balcony into a cozy and stylish space!",
             beforeImage: "old_balcony",
             afterImage: "new_balcony"),
            (title: "Garden Design",
             subtitle: "Upload a pic, choose a style, let AI design the garden!",
             beforeImage: "old_garden",
             afterImage: "new_garden"),
            (title: "Bathroom Design",
             subtitle: "Transform your bathroom with modern and stylish designs!",
             beforeImage: "old_bathroom",
             afterImage: "new_bathroom")
        ]
        
        return LazyVStack(spacing: 30) {
            ForEach(designCards, id: \.title) { card in
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
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
                                        print("Premium button tapped")
                                        showPaywall = true
                                    } label: {
                                        ProBadgeView()
                                            .scaleEffect(1.2)
                                    }
                                    .contentShape(Rectangle())
                                }
                                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 120, height: 44)
                                
                                Spacer()
                                
                                // Title
                                Text("archit ai")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                
                                Spacer()
                                
                                // Settings Button
                                HStack {
                                    Button {
                                        print("Settings button tapped")
                                        showSettings = true
                                    } label: {
                                        Image(systemName: "gearshape.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(Constants.Colors.textPrimary)
                                    }
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
                                    print("Premium button tapped (iPhone)")
                                    showPaywall.toggle()
                                }) {
                                    ProBadgeView()
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Spacer()
                                
                                Button(action: {
                                    print("Settings button tapped (iPhone)")
                                    showSettings.toggle()
                                }) {
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(Constants.Colors.textPrimary)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .overlay(
                                Text("archit ai")
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
                                (title: "Room Design",
                                 subtitle: "Upload a pic, choose a style, let AI design the room!",
                                 beforeImage: "old_room",
                                 afterImage: "new_room"),
                                (title: "Bedroom Design",
                                 subtitle: "Transform your bedroom into a cozy and stylish space!",
                                 beforeImage: "old_bedroom",
                                 afterImage: "new_bedroom"),
                                (title: "Balcony Design",
                                 subtitle: "Transform your balcony into a cozy and stylish space!",
                                 beforeImage: "old_balcony",
                                 afterImage: "new_balcony"),
                                (title: "Garden Design",
                                 subtitle: "Upload a pic, choose a style, let AI design the garden!",
                                 beforeImage: "old_garden",
                                 afterImage: "new_garden"),
                                (title: "Bathroom Design",
                                 subtitle: "Transform your bathroom with modern and stylish designs!",
                                 beforeImage: "old_bathroom",
                                 afterImage: "new_bathroom")
                            ]
                            
                            LazyVStack(spacing: 25) {
                                ForEach(designCards, id: \.title) { card in
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
    }
}