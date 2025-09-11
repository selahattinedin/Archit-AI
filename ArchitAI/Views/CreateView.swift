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
                .navigationTitle("Create Design")
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
                            viewModel.onComplete(design)
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
                    // Paywall kapatıldığında showPaywall'ı false yap
                    showPaywall = false
                }
        }
        .onAppear {
            // Firebase user ID'yi CreateDesignViewModel'e set et
            viewModel.currentUserID = authService.currentUserId
            
            // Premium kontrolü - abone değilse Paywall göster
            if !purchases.isPro {
                showPaywall = true
            }
        }
        .onChange(of: purchases.isPro) { isPro in
            // Premium durumu değiştiğinde paywall'ı güncelle
            if isPro {
                // Kullanıcı premium oldu, paywall'ı kapat
                showPaywall = false
                print("✅ CreateView: User became premium, hiding paywall")
            } else {
                // Kullanıcı premium değil, paywall'ı göster
                showPaywall = true
                print("❌ CreateView: User is not premium, showing paywall")
            }
        }
    }
}
