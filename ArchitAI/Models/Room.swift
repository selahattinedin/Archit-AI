import Foundation

struct Room: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let icon: String
    let description: String
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
    case living = "Living"
    case bedroom = "Bedroom"
    case kitchen = "Kitchen"
    case bathroom = "Bathroom"
    case workspace = "Workspace"
    case outdoor = "Outdoor"
    case entertainment = "Entertainment"
    case storage = "Storage"
    case specialty = "Specialty"
}