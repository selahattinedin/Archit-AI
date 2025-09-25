import SwiftUI

struct PhotoSelectionStepView: View {
    @Binding var selectedPhoto: UIImage?
    let onContinue: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: UIDevice.current.userInterfaceIdiom == .pad ? 40 : 24) {
                PhotoUploadView(selectedImage: $selectedPhoto)
                    .padding(.horizontal)
                
                // Continue Button inside scrollable area
                ContinueButton(
                    title: "continue".localized(with: languageManager.languageUpdateTrigger),
                    isEnabled: selectedPhoto != nil,
                    action: onContinue
                )
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
            .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20)
        }
    }
}