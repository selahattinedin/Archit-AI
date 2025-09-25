import SwiftUI

struct ModernRoomSelectionView: View {
    let rooms: [Room]
    @Binding var selectedRoom: Room?
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
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
        ZStack {
            VStack(spacing: 12) {
                ZStack {
                    // Gradient background for icon
                    if !room.gradientColors.isEmpty {
                        LinearGradient(
                            colors: room.gradientColors.map { 
                                let color = Color(hex: $0)
                                return colorScheme == .dark ? color : color.opacity(0.3)
                            },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 40)
                        .cornerRadius(12)
                        .opacity(colorScheme == .dark ? 0.8 : 0.6)
                    }
                    
                    Image(room.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                        .clipped()
                        .cornerRadius(12)
                        .foregroundColor(colorScheme == .dark ? .white : .primary)
                        .shadow(color: colorScheme == .dark ? .black.opacity(0.3) : .clear, radius: 2, x: 0, y: 1)
                    
                    // Selection Checkmark
                    if isSelected {
                        VStack {
                            HStack {
                                Spacer()
                                ZStack {
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 32, height: 32)
                                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .padding(.top, 12)
                                .padding(.trailing, 12)
                            }
                            Spacer()
                        }
                    }
                }
                
                VStack(spacing: 4) {
                    Text(room.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? Color.orange : Constants.Colors.textPrimary)
                    
                    Text(room.description)
                        .font(.system(size: 13))
                        .foregroundColor(isSelected ? Color.orange : Constants.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? 
                    Color.orange.opacity(0.1) : 
                    (colorScheme == .dark ? Constants.Colors.cardBackground : Color.white)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.orange : Constants.Colors.cardBorder, lineWidth: 1.5)
            )
        }
    }
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        let int = Int(hex, radix: 16) ?? 0
        self.init(
            red: Double((int >> 16) & 0xFF) / 255,
            green: Double((int >> 8) & 0xFF) / 255,
            blue: Double(int & 0xFF) / 255
        )
    }
}

#Preview {
    ModernRoomSelectionView(
        rooms: RoomProvider().getAllRooms(),
        selectedRoom: .constant(nil)
    )
}
