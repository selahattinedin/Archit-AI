import SwiftUI

struct CreateNavigationBar: View {
    @ObservedObject var viewModel: CreateDesignViewModel
    let currentStep: Int
    let showResult: Bool
    let isLoading: Bool
    let onBack: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        HStack {
            // Geri butonu sadece 1. ve 2. adımda görünür
            if (currentStep == 1 || currentStep == 2) && !showResult && !isLoading {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Constants.Colors.textPrimary)
                }
            }
            
            Spacer()
            
            // Çarpı butonu sadece 1. ve 2. adımda görünür
            if !showResult && !isLoading && (currentStep == 1 || currentStep == 2) {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .foregroundColor(Constants.Colors.textPrimary)
                }
            }
        }
    }
}
