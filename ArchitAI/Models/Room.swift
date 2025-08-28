import Foundation

struct Room: Identifiable, Codable {
    let id: UUID
    let name: String
    let icon: String
    let description: String
    
    init(id: UUID = UUID(), name: String, icon: String, description: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
    }
}