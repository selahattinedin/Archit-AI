import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @EnvironmentObject var authService: FirebaseAuthService
    @EnvironmentObject var purchases: RevenueCatService
    @State private var selectedTab = 0
    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var scrollOffset: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: { showPaywall = true }) {
                            ProBadgeView()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Constants.Colors.textPrimary)
                        }
                    }
                    .padding(.top, 16)
                }
                .background(Constants.Colors.cardBackground.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                .padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 25) {
                        DesignOptionCard(
                            title: "Interior Design",
                            subtitle: "Upload a pic, choose a style, let AI design the room!",
                            beforeImage: "old_room",
                            afterImage: "new_room"
                        ) {
                            if purchases.isPro {
                                viewModel.isShowingPhotoUpload = true
                            } else {
                                showPaywall = true
                            }
                        }
                        
                        DesignOptionCard(
                            title: "Bedroom Design",
                            subtitle: "Transform your bedroom into a cozy and stylish space!",
                            beforeImage: "old_bedroom",
                            afterImage: "new_bedroom"
                        ) {
                            if purchases.isPro {
                                viewModel.isShowingPhotoUpload = true
                            } else {
                                showPaywall = true
                            }
                        }
                        
                        DesignOptionCard(
                            title: "Balcony Design",
                            subtitle: "Transform your balcony into a cozy and stylish space!",
                            beforeImage: "old_balcony",
                            afterImage: "new_balcony"
                        ) {
                            if purchases.isPro {
                                viewModel.isShowingPhotoUpload = true
                            } else {
                                showPaywall = true
                            }
                        }
                        
                        DesignOptionCard(
                            title: "Garden Design",
                            subtitle: "Upload a pic, choose a style, let AI design the garden!",
                            beforeImage: "old_garden",
                            afterImage: "new_garden"
                        ) {
                            if purchases.isPro {
                                viewModel.isShowingPhotoUpload = true
                            } else {
                                showPaywall = true
                            }
                        }
                        
                        DesignOptionCard(
                            title: "Bathroom Design",
                            subtitle: "Transform your bathroom with modern and stylish designs!",
                            beforeImage: "old_bathroom",
                            afterImage: "new_bathroom"
                        ) {
                            if purchases.isPro {
                                viewModel.isShowingPhotoUpload = true
                            } else {
                                showPaywall = true
                            }
                        }
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Constants.Colors.cardBackground,
                        colorScheme == .dark ? Color.black : Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationBarHidden(true)
        }
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
