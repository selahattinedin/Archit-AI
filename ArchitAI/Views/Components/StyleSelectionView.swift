import SwiftUI

struct StyleSelectionView: View {
    let styles: [DesignStyle]
    @Binding var selectedStyle: DesignStyle?
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
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
        VStack(spacing: 12) {
            Image(style.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)
            
            VStack(spacing: 4) {
                Text(style.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? (colorScheme == .dark ? .white : .black) : Constants.Colors.textSecondary)
                
                Text(style.description)
                    .font(.system(size: 13))
                    .foregroundColor(isSelected ? (colorScheme == .dark ? .white : .black) : Constants.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Constants.Colors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? (colorScheme == .dark ? Color.white : Color.black) : Constants.Colors.cardBorder, lineWidth: 1.5)
        )
    }
}