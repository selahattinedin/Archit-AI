import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CreateDesignViewModel
    @EnvironmentObject var authService: FirebaseAuthService
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var currentStep = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var isLoading = false
    @State private var showResult = false
    @State private var generatedDesign: Design?
    @Binding var tabBarHidden: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private let rooms = RoomProvider().getAllRooms()
    private let styles = StyleProvider.styles
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    StepsProgressView(currentStep: currentStep)
                        .padding(.top, 10)
                    
                    Group {
                        switch currentStep {
                        case 0:
                            PhotoSelectionStepView(
                                selectedPhoto: $viewModel.selectedPhoto,
                                onContinue: { withAnimation { currentStep = 1 } }
                            )
                            
                        case 1:
                            RoomSelectionStepView(
                                selectedRoom: $viewModel.selectedRoom,
                                rooms: rooms,
                                onContinue: { withAnimation { currentStep = 2 } }
                            )
                            
                        case 2:
                            StyleSelectionStepView(
                                selectedStyle: $viewModel.selectedStyle,
                                styles: styles,
                                isLoading: isLoading,
                                onGenerate: {
                                    isLoading = true
                                    Task {
                                        await viewModel.createDesign()
                                        if let design = viewModel.generatedDesign {
                                            generatedDesign = design
                                            isLoading = false
                                            showResult = true
                                        }
                                    }
                                },
                                error: viewModel.error
                            )
                            
                        default:
                            EmptyView()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Create Design")
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: Group {
                        if currentStep > 0 && !showResult && !isLoading {
                            Button {
                                withAnimation {
                                    if currentStep == 2 {
                                        viewModel.selectedStyle = nil
                                    }
                                    currentStep -= 1
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(Constants.Colors.textPrimary)
                            }
                        }
                    },
                    trailing: (!showResult && !isLoading) ? Button {
                        withAnimation {
                            viewModel.selectedPhoto = nil
                            viewModel.selectedRoom = nil
                            viewModel.selectedStyle = nil
                            currentStep = 0
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Constants.Colors.textPrimary)
                    } : nil
                )
                
                if isLoading {
                    LoadingView()
                        .transition(.opacity)
                }
                
                if showResult, let design = generatedDesign {
                    DesignDetailView(
                        design: design,
                        isFromCreate: true, // Create'den geliyor
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
        .onAppear {
            // Firebase user ID'yi CreateDesignViewModel'e set et
            viewModel.currentUserID = authService.currentUserId
        }
    }
}
