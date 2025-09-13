import Foundation

struct Room: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let icon: String
    let description: String
    
    var localizedName: String {
        return name.localized(with: LanguageManager.shared.languageUpdateTrigger)
    }
    
    var localizedDescription: String {
        return description.localized(with: LanguageManager.shared.languageUpdateTrigger)
    }
    let category: RoomCategory
    let gradientColors: [String]
    
    init(id: UUID = UUID(), name: String, icon: String, description: String, category: RoomCategory, gradientColors: [String] = []) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
        self.category = category
        self.gradientColors = gradientColors
    }
}

enum RoomCategory: String, CaseIterable, Codable {
    case living = "room_category_living"
    case bedroom = "room_category_bedroom"
    case kitchen = "room_category_kitchen"
    case bathroom = "room_category_bathroom"
    case workspace = "room_category_workspace"
    case outdoor = "room_category_outdoor"
    case entertainment = "room_category_entertainment"
    case storage = "room_category_storage"
    case specialty = "room_category_specialty"
}