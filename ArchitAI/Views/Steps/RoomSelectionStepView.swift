import SwiftUI

struct RoomSelectionStepView: View {
    @Binding var selectedRoom: Room?
    let rooms: [Room]
    let onContinue: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack {
                    RoomSelectionView(
                        rooms: rooms,
                        selectedRoom: $selectedRoom,
                        onNext: { }
                    )
                    .padding(.horizontal)
                    .padding(.top, 1)
                    
                    // Extra space for button
                    Color.clear
                        .frame(height: 80)
                }
            }
            
            // Fixed Button at bottom
            VStack(spacing: 0) {
                Button(action: onContinue) {
                    Text("Next")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .frame(height: 46)
                        .frame(maxWidth: .infinity)
                        .background(selectedRoom != nil ? (colorScheme == .dark ? Color.white : Color.black) : Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(selectedRoom == nil)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .padding(.bottom, 8)
            }
            .background(Constants.Colors.cardBackground)
        }
    }
}