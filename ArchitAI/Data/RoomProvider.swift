import Foundation

protocol RoomProviding {
    func getAllRooms() -> [Room]
    func getRoomsByCategory() -> [RoomCategory: [Room]]
}

final class RoomProvider: RoomProviding {
    func getAllRooms() -> [Room] {
        return [
            // Living Spaces
            Room(
                name: "room_living_room",
                icon: "living-room",
                description: "room_living_room_desc",
                category: .living,
                gradientColors: ["FF6B6B", "4ECDC4"]
            ),
            Room(
                name: "room_dining_room",
                icon: "dining_room",
                description: "room_dining_room_desc",
                category: .living,
                gradientColors: ["A8E6CF", "FFD93D"]
            ),
            
            // Bedrooms
            Room(
                name: "room_bedroom",
                icon: "bedroom",
                description: "room_bedroom_desc",
                category: .bedroom,
                gradientColors: ["667eea", "764ba2"]
            ),
            Room(
                name: "room_kids_room",
                icon: "kids_room",
                description: "room_kids_room_desc",
                category: .bedroom,
                gradientColors: ["4facfe", "00f2fe"]
            ),
            
            // Kitchen & Dining
            Room(
                name: "room_kitchen",
                icon: "kitchen",
                description: "room_kitchen_desc",
                category: .kitchen,
                gradientColors: ["fa709a", "fee140"]
            ),
            
            // Bathrooms
            Room(
                name: "room_bathroom",
                icon: "bathroom",
                description: "room_bathroom_desc",
                category: .bathroom,
                gradientColors: ["89f7fe", "66a6ff"]
            ),
            
            // Workspaces
            Room(
                name: "room_home_office",
                icon: "office",
                description: "room_home_office_desc",
                category: .workspace,
                gradientColors: ["667eea", "764ba2"]
            ),
            Room(
                name: "room_study_room",
                icon: "study-room",
                description: "room_study_room_desc",
                category: .workspace,
                gradientColors: ["f093fb", "f5576c"]
            ),
            
            // Outdoor Spaces
            Room(
                name: "room_garden",
                icon: "garden",
                description: "room_garden_desc",
                category: .outdoor,
                gradientColors: ["43e97b", "38f9d7"]
            ),
            Room(
                name: "room_balcony",
                icon: "balcony",
                description: "room_balcony_desc",
                category: .outdoor,
                gradientColors: ["fa709a", "fee140"]
            ),
            
            // Entertainment
            Room(
                name: "room_entertainment",
                icon: "entertainment",
                description: "room_entertainment_desc",
                category: .entertainment,
                gradientColors: ["fdbb2d", "22c1c3"]
            ),
            
            // Storage & Utility
            Room(
                name: "room_entryway",
                icon: "entryway",
                description: "room_entryway_desc",
                category: .storage,
                gradientColors: ["fa709a", "fee140"]
            ),
            Room(
                name: "room_laundry_room",
                icon: "laundry",
                description: "room_laundry_room_desc",
                category: .storage,
                gradientColors: ["89f7fe", "66a6ff"]
            ),
            Room(
                name: "room_pantry",
                icon: "pantry",
                description: "room_pantry_desc",
                category: .storage,
                gradientColors: ["A8E6CF", "FFD93D"]
            ),
            
            // Specialty Rooms
            Room(
                name: "room_home_gym",
                icon: "gym",
                description: "room_home_gym_desc",
                category: .specialty,
                gradientColors: ["89f7fe", "66a6ff"]
            ),
            Room(
                name: "room_library",
                icon: "library",
                description: "room_library_desc",
                category: .specialty,
                gradientColors: ["fdbb2d", "22c1c3"]
            )
        ]
    }
    
    func getRoomsByCategory() -> [RoomCategory: [Room]] {
        let rooms = getAllRooms()
        return Dictionary(grouping: rooms) { $0.category }
    }
}


