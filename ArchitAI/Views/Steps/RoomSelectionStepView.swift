import SwiftUI

struct RoomSelectionStepView: View {
    @StateObject private var viewModel: RoomSelectionViewModel
    let onContinue: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var animateContent = false
    
    init(selectedRoom: Binding<Room?>, rooms: [Room], onContinue: @escaping () -> Void) {
        let vm = RoomSelectionViewModel(
            selectedRoom: selectedRoom.wrappedValue,
            rooms: rooms,
            onRoomSelected: { room in
                selectedRoom.wrappedValue = room
            }
        )
        _viewModel = StateObject(wrappedValue: vm)
        self.onContinue = onContinue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                roomSelectionGrid
                    .padding(.bottom, 24)
            }
        }
        .padding(.horizontal, 20)
        .safeAreaInset(edge: .bottom) {
            bottomButton
                .padding(.horizontal, 20)
                .padding(.top, 8)
        }
        .onAppear {
            animateContent = true
        }
    }
    
    private var roomSelectionGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(viewModel.rooms) { room in
                roomCard(room: room)
            }
        }
        .padding(.top, 20)
    }
    
    private func roomCard(room: Room) -> some View {
        let isSelected = viewModel.isSelected(room)
        
        return VStack {
            VStack(spacing: 12) {
                ZStack {
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

                    if isSelected {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Circle().fill(.orange))
                                    .padding(8)
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
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.orange.opacity(0.15) : (colorScheme == .dark ? Constants.Colors.cardBackground : Color.white))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.orange : Constants.Colors.cardBorder, lineWidth: 2)
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectRoom(room)
        }
    }
    
    private var bottomButton: some View {
        ContinueButton(
            title: "Continue",
            isEnabled: viewModel.selectedRoom != nil,
            action: onContinue
        )
    }
}
