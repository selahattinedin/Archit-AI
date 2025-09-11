import SwiftUI

struct PhotoSelectionStepView: View {
    @Binding var selectedPhoto: UIImage?
    let onContinue: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content without scroll
            VStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 40 : 24) {
                // Photo Upload Section
                PhotoUploadView(selectedImage: $selectedPhoto)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20)
            
            // Fixed Button at bottom
            VStack(spacing: 0) {
                ContinueButton(
                    title: "Continue",
                    isEnabled: selectedPhoto != nil,
                    action: onContinue
                )
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
    }
}