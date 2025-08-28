import Foundation

protocol RoomProviding {
    func getAllRooms() -> [Room]
}

final class RoomProvider: RoomProviding {
    func getAllRooms() -> [Room] {
        return [
            Room(
                name: "Living Room",
                icon: "sofa.fill",
                description: "Transform your living space"
            ),
            Room(
                name: "Bedroom",
                icon: "bed.double.fill",
                description: "Create your perfect sanctuary"
            ),
            Room(
                name: "Kitchen",
                icon: "cooktop.fill",
                description: "Design your dream kitchen"
            ),
            Room(
                name: "Bathroom",
                icon: "shower.fill",
                description: "Renovate your bathroom"
            ),
            Room(
                name: "Office",
                icon: "desk.fill",
                description: "Build your ideal workspace"
            ),
            Room(
                name: "Garden",
                icon: "leaf.fill",
                description: "Design your outdoor oasis"
            ),
            Room(
                name: "Dining Room",
                icon: "fork.knife",
                description: "Create an elegant dining space"
            ),
            Room(
                name: "Kids Room",
                icon: "car.fill",
                description: "Design a playful children's room"
            ),
            Room(
                name: "Game Room",
                icon: "gamecontroller.fill",
                description: "Build your entertainment zone"
            ),
            Room(
                name: "Home Gym",
                icon: "figure.walk",
                description: "Create your fitness space"
            ),
            Room(
                name: "Library",
                icon: "book.fill",
                description: "Design your reading sanctuary"
            ),
            Room(
                name: "Home Theater",
                icon: "tv.fill",
                description: "Build your entertainment space"
            ),
            Room(
                name: "Balcony",
                icon: "house.fill",
                description: "Transform your outdoor area"
            ),
            Room(
                name: "Walk-in Closet",
                icon: "tshirt.fill",
                description: "Design your dream closet"
            ),
            Room(
                name: "Laundry Room",
                icon: "washer.fill",
                description: "Organize your laundry space"
            ),
            // Entryway (merged corridor/hall)
            Room(
                name: "Entryway",
                icon: "rectangle.portrait",
                description: "Elevate your entryway"
            )
        ]
    }
}


