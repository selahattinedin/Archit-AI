import Foundation

struct DesignStyle: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let image: String
    let tags: [String]
    
    var localizedName: String {
        return name.localized(with: LanguageManager.shared.languageUpdateTrigger)
    }
    
    var localizedDescription: String {
        return description.localized(with: LanguageManager.shared.languageUpdateTrigger)
    }
    
    init(id: UUID = UUID(), name: String, description: String, image: String, tags: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.tags = tags
    }
}