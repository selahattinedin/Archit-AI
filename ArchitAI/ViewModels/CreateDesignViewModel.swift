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
    let onComplete: (Design) -> Void // private kaldırıldı
    
    // Firebase user ID'yi sakla
    var currentUserID: String?
    
    init(onComplete: @escaping (Design) -> Void) {
        self.onComplete = onComplete
    }
    
    @MainActor
    func createDesign() async {
        guard let room = selectedRoom,
              let style = selectedStyle,
              let photo = selectedPhoto else {
            print("Missing required information for design")
            return
        }
        
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