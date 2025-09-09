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
                name: "Living Room",
                icon: "living-room",
                description: "Transform your main living space",
                category: .living,
                gradientColors: ["FF6B6B", "4ECDC4"]
            ),
            Room(
                name: "Dining Room",
                icon: "dining_room",
                description: "Create an elegant dining experience",
                category: .living,
                gradientColors: ["A8E6CF", "FFD93D"]
            ),
            
            // Bedrooms
            Room(
                name: "Bedroom",
                icon: "bedroom",
                description: "Create your perfect sanctuary",
                category: .bedroom,
                gradientColors: ["667eea", "764ba2"]
            ),
            Room(
                name: "Kids Room",
                icon: "kids_room",
                description: "Create a playful children's space",
                category: .bedroom,
                gradientColors: ["4facfe", "00f2fe"]
            ),
            
            // Kitchen & Dining
            Room(
                name: "Kitchen",
                icon: "kitchen",
                description: "Design your dream culinary space",
                category: .kitchen,
                gradientColors: ["fa709a", "fee140"]
            ),
            
            // Bathrooms
            Room(
                name: "Bathroom",
                icon: "bathroom",
                description: "Create a luxurious spa experience",
                category: .bathroom,
                gradientColors: ["89f7fe", "66a6ff"]
            ),
            
            // Workspaces
            Room(
                name: "Home Office",
                icon: "office",
                description: "Build your productive workspace",
                category: .workspace,
                gradientColors: ["667eea", "764ba2"]
            ),
            Room(
                name: "Study Room",
                icon: "study-room",
                description: "Create a focused study environment",
                category: .workspace,
                gradientColors: ["f093fb", "f5576c"]
            ),
            
            // Outdoor Spaces
            Room(
                name: "Garden",
                icon: "garden",
                description: "Design your outdoor oasis",
                category: .outdoor,
                gradientColors: ["43e97b", "38f9d7"]
            ),
            Room(
                name: "Balcony",
                icon: "balcony",
                description: "Transform your outdoor area",
                category: .outdoor,
                gradientColors: ["fa709a", "fee140"]
            ),
            
            // Entertainment
            Room(
                name: "Entertainment",
                icon: "entertainment",
                description: "Build your entertainment space",
                category: .entertainment,
                gradientColors: ["fdbb2d", "22c1c3"]
            ),
            
            // Storage & Utility
            Room(
                name: "Entryway",
                icon: "entryway",
                description: "Create an organized entry space",
                category: .storage,
                gradientColors: ["fa709a", "fee140"]
            ),
            
            // Specialty Rooms
            Room(
                name: "Home Gym",
                icon: "gym",
                description: "Create your fitness sanctuary",
                category: .specialty,
                gradientColors: ["89f7fe", "66a6ff"]
            ),
            Room(
                name: "Library",
                icon: "library",
                description: "Design your reading sanctuary",
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


