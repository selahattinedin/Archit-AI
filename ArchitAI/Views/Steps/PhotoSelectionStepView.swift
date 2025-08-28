import SwiftUI

struct PhotoSelectionStepView: View {
    @Binding var selectedPhoto: UIImage?
    let onContinue: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content without scroll
            VStack(spacing: 24) {
                // Photo Upload Section
                PhotoUploadView(selectedImage: $selectedPhoto)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 1)
            
            // Fixed Button at bottom
            VStack(spacing: 0) {
                Button(action: onContinue) {
                    Text("Next")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .frame(height: 46)
                        .frame(maxWidth: .infinity)
                        .background(selectedPhoto != nil ? (colorScheme == .dark ? Color.white : Color.black) : Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(selectedPhoto == nil)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .padding(.bottom, 8)
            }
            .background(Constants.Colors.cardBackground)
        }
    }
}