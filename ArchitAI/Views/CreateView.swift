import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CreateDesignViewModel
    @EnvironmentObject var authService: FirebaseAuthService
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var purchases: RevenueCatService
    @State private var currentStep = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var isLoading = false
    @State private var showResult = false
    @State private var generatedDesign: Design?
    @State private var showPaywall = false
    @Binding var tabBarHidden: Bool
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var languageManager = LanguageManager.shared
    
    private let rooms = RoomProvider().getAllRooms()
    private let styles = StyleProvider.styles
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    StepsProgressView(currentStep: currentStep)
                        .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 20 : 10)
                    
                    CreateStepsView(
                        viewModel: viewModel,
                        currentStep: $currentStep,
                        isLoading: $isLoading,
                        showResult: $showResult,
                        generatedDesign: $generatedDesign,
                        showPaywall: $showPaywall
                    )
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("create".localized(with: languageManager.languageUpdateTrigger))
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if (currentStep == 1 || currentStep == 2) && !showResult && !isLoading {
                            Button(action: {
                                withAnimation {
                                    if currentStep == 2 {
                                        viewModel.selectedStyle = nil
                                    }
                                    currentStep -= 1
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Constants.Colors.textPrimary)
                                    .accessibilityLabel("back".localized(with: languageManager.languageUpdateTrigger))
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !showResult && !isLoading && (currentStep == 1 || currentStep == 2) {
                            Button(action: {
                                withAnimation {
                                    viewModel.selectedPhoto = nil
                                    viewModel.selectedRoom = nil
                                    viewModel.selectedStyle = nil
                                    currentStep = 0
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(Constants.Colors.textPrimary)
                                    .accessibilityLabel("cancel".localized)
                            }
                        }
                    }
                }
                
                if isLoading {
                    LoadingView()
                        .transition(.opacity)
                }
                
                if showResult, let design = generatedDesign {
                    DesignDetailView(
                        design: design,
                        isFromCreate: true,
                        onSave: {
                            print("💾 CreateView: Save butonuna basıldı - \(design.title)")
                            
                            // Hemen History tab'ına geç
                            NotificationCenter.default.post(name: Notification.Name("SwitchToHistoryTab"), object: nil)
                            print("💾 CreateView: SwitchToHistoryTab notification gönderildi")
                            
                            // Optimistic insert: History'de anında göster
                            if let userID = authService.currentUserId,
                               let before = design.beforeImage,
                               let after = design.afterImage {
                                let localDesign = Design(
                                    id: design.id,
                                    title: design.title,
                                    style: design.style,
                                    room: design.room,
                                    beforeImage: before,
                                    afterImage: after,
                                    userID: userID,
                                    createdAt: design.createdAt
                                )
                                homeViewModel.addDesign(localDesign)
                            }
                            
                            // Arka planda kaydet
                            Task {
                                if let userID = authService.currentUserId {
                                    await homeViewModel.saveDesignToFirebase(design: design, userID: userID)
                                    // Kaydetme tamamlandıktan sonra History'yi güncelle
                                    await homeViewModel.loadDesignsFromFirebase(userID: userID)
                                }
                                
                                // Design created notification gönder
                                NotificationCenter.default.post(name: Notification.Name("DesignCreated"), object: nil)
                                print("💾 CreateView: DesignCreated notification gönderildi")
                            }
                        },
                        onClose: {
                            withAnimation {
                                showResult = false
                                isLoading = false
                                currentStep = 0
                                viewModel.selectedPhoto = nil
                                viewModel.selectedRoom = nil
                                viewModel.selectedStyle = nil
                            }
                        }
                    )
                    .environmentObject(homeViewModel)
                }
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(purchasesService: purchases)
                .onDisappear {
                    showPaywall = false
                }
        }
        .onAppear {
            viewModel.currentUserID = authService.currentUserId
            
            if !purchases.isPro {
                showPaywall = true
            }
        }
        .onChange(of: purchases.isPro) { isPro in
            if isPro {
                showPaywall = false
            } else {
                showPaywall = true
            }
        }
    }
}