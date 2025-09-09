import SwiftUI

class RoomSelectionViewModel: ObservableObject {
    @Published var selectedRoom: Room?
    let rooms: [Room]
    let onRoomSelected: (Room) -> Void
    
    init(selectedRoom: Room? = nil, rooms: [Room], onRoomSelected: @escaping (Room) -> Void) {
        self.selectedRoom = selectedRoom
        self.rooms = rooms
        self.onRoomSelected = onRoomSelected
    }
    
    func selectRoom(_ room: Room) {
        selectedRoom = room
        onRoomSelected(room)
        Constants.Haptics.selection()
    }
    
    func isSelected(_ room: Room) -> Bool {
        return selectedRoom?.id == room.id
    }
}
