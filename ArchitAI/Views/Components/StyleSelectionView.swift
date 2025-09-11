import SwiftUI

struct StyleSelectionView: View {
    let styles: [DesignStyle]
    @Binding var selectedStyle: DesignStyle?
    
    var body: some View {
        let columns = UIDevice.current.userInterfaceIdiom == .pad ? [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ] : [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        LazyVGrid(columns: columns, spacing: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 16) {
            ForEach(styles) { style in
                StyleCard(style: style, isSelected: selectedStyle?.id == style.id)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedStyle = style
                        }
                    }
            }
        }
    }
}

private struct StyleCard: View {
    let style: DesignStyle
    let isSelected: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                ZStack {
                    Image(style.image)
                        .resizable()
                        .aspectRatio(4/3, contentMode: .fill)
                        .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 160 : 140)
                        .clipped()
                        .cornerRadius(12)
                    
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
                    Text(style.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? Color.orange : Constants.Colors.textPrimary)
                    
                    Text(style.description)
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