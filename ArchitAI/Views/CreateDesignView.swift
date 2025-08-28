import SwiftUI
import PhotosUI

struct CreateDesignView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreateDesignViewModel(onComplete: { _ in })
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Photo Upload
                PhotoUploadView(selectedImage: $viewModel.selectedPhoto)
                
                Spacer()
                
                // Generate Button
                if viewModel.selectedPhoto != nil {
                    Button(action: generateDesign) {
                        Text("Generate Design")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(25)
                    }
                    .padding()
                }
            }
            .padding()
            .navigationTitle("Create Design")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func generateDesign() {
        // Handle design generation
        print("Generating design...")
    }
}
