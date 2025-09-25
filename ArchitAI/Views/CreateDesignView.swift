import SwiftUI
import PhotosUI

struct CreateDesignView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreateDesignViewModel(onComplete: { _ in })
    @EnvironmentObject var purchases: RevenueCatService
    @StateObject private var languageManager = LanguageManager.shared
    
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
                    Button("cancel".localized(with: languageManager.languageUpdateTrigger)) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func generateDesign() {
        // 🔒 PREMIUM KONTROLÜ - Abonelik almamış kullanıcılar image üretemez
        guard purchases.isPro else {
            print("🚫 CreateDesignView: User is not premium, blocking image generation")
            // Burada paywall gösterebilirsiniz
            return
        }
        
        print("✅ CreateDesignView: User is premium, proceeding with image generation")
        // Handle design generation
        print("Generating design...")
    }
}
