import SwiftUI

struct RoomSelectionView: View {
    let rooms: [Room]
    @Binding var selectedRoom: Room?
    let onNext: () -> Void
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(rooms) { room in
                RoomCard(room: room, isSelected: selectedRoom?.id == room.id)
                    .onTapGesture {
                        selectedRoom = room
                    }
            }
        }
    }
}

private struct RoomCard: View {
    let room: Room
    let isSelected: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isSelected ? "\(room.icon).fill" : room.icon)
                .font(.system(size: 32))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(height: 50)
                .padding(.top, 8)
              
            VStack(spacing: 4) {
                Text(room.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .black)
                  
                Text(room.description)
                    .font(.system(size: 13))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(isSelected ? Color.black : Color.gray.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.black : Color.gray.opacity(0.3), lineWidth: isSelected ? 3 : 1)
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
