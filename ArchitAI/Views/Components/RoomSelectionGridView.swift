import SwiftUI

struct RoomSelectionGridView: View {
    let rooms: [Room]
    let onSelect: (Room) -> Void
    @State private var selectedRoomId: UUID?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 150), spacing: 16)
        ], spacing: 16) {
            ForEach(rooms) { room in
                Button {
                    selectedRoomId = room.id
                    onSelect(room)
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: selectedRoomId == room.id ? "\(room.icon).fill" : room.icon)
                            .font(.system(size: 32))
                            .foregroundColor(
                                selectedRoomId == room.id ?
                                (colorScheme == .dark ? .black : .white) :
                                Constants.Colors.textSecondary
                            )
                        
                        Text(room.name)
                            .font(.headline)
                            .foregroundColor(
                                selectedRoomId == room.id ?
                                (colorScheme == .dark ? .black : .white) :
                                Constants.Colors.textPrimary
                            )
                        
                        Text(room.description)
                            .font(.caption)
                            .foregroundColor(
                                selectedRoomId == room.id ?
                                (colorScheme == .dark ? .black.opacity(0.8) : .white.opacity(0.8)) :
                                Constants.Colors.textSecondary
                            )
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .background(
                        selectedRoomId == room.id ?
                        (colorScheme == .dark ? .white : .black) :
                        Constants.Colors.cardBackground
                    )
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedRoomId == room.id ?
                                (colorScheme == .dark ? .white : .black) :
                                Constants.Colors.cardBorder,
                                lineWidth: selectedRoomId == room.id ? 2 : 1
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedRoomId)
            }
        }
        .padding(.horizontal)
    }
}
