import SwiftUI

struct CreateStepsView: View {
    @ObservedObject var viewModel: CreateDesignViewModel
    @Binding var currentStep: Int
    @Binding var isLoading: Bool
    @Binding var showResult: Bool
    @Binding var generatedDesign: Design?
    @Binding var showPaywall: Bool
    @EnvironmentObject var purchases: RevenueCatService
    
    private let rooms = RoomProvider().getAllRooms()
    private let styles = StyleProvider.styles
    
    var body: some View {
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
                        if !purchases.isPro {
                            showPaywall = true
                            return
                        }
                        
                        isLoading = true
                        viewModel.resetState()
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
}
