import SwiftUI

class CreateDesignViewModel: ObservableObject {
    @Published var selectedRoom: Room?
    @Published var selectedStyle: DesignStyle?
    @Published var selectedPhoto: UIImage?
    @Published var generatedImage: UIImage?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var generatedDesign: Design?
    @Published var isComplete = false
    
    private let aiService = AIDesignService()
    private let revenueCatService = RevenueCatService.shared
    let onComplete: (Design) -> Void // private kaldırıldı
    
    // Firebase user ID'yi sakla
    var currentUserID: String?
    
    init(onComplete: @escaping (Design) -> Void) {
        self.onComplete = onComplete
    }
    
    func resetState() {
        generatedImage = nil
        generatedDesign = nil
        isComplete = false
        error = nil
        isLoading = false
    }
    
    @MainActor
    func createDesign() async {
        guard let room = selectedRoom,
              let style = selectedStyle,
              let photo = selectedPhoto else {
            print("Missing required information for design")
            return
        }
        
        // 🔒 PREMIUM KONTROLÜ - Abonelik almamış kullanıcılar image üretemez
        guard revenueCatService.isPro else {
            print("🚫 CreateDesignViewModel: User is not premium, blocking image generation")
            self.error = NSError(domain: "PremiumRequired", code: 403, userInfo: [
                NSLocalizedDescriptionKey: "Premium subscription required to generate images. Please subscribe to continue."
            ])
            return
        }
        
        print("✅ CreateDesignViewModel: User is premium, proceeding with image generation")
        
        isLoading = true
        error = nil
        
        do {
            let generatedImage = try await aiService.generateDesign(
                from: photo,
                style: style,
                room: room
            )
            self.generatedImage = generatedImage
            
            // Yeni tasarımı oluştur
            let design = Design(
                title: "\(room.name) - \(style.name)",
                style: style,
                room: room,
                beforeImage: photo,
                afterImage: generatedImage,
                userID: currentUserID
            )
            
            self.generatedDesign = design
            
            isLoading = false
            isComplete = true
        } catch {
            print("Generation error: \(error)")  // Debug için
            self.error = error
            isLoading = false
        }
    }
}