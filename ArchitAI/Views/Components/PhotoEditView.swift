import SwiftUI

struct PhotoEditView: View {
    @Environment(\.dismiss) private var dismiss
    let selectedImage: UIImage
    let onBack: () -> Void
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Toolbar
            HStack {
                Button {
                    onBack()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.black)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Image Preview
            Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            
            Spacer()
            
            // Continue Button
            Button {
                onContinue()
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(Constants.Colors.proBackground)
                    .cornerRadius(28)
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
}
