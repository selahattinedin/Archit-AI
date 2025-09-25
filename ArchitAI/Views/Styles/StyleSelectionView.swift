import SwiftUI

struct StyleSelectionView: View {
    let styles: [DesignStyle]
    @Binding var selectedStyle: DesignStyle?
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = UIDevice.current.userInterfaceIdiom == .pad ? (screenWidth - 80) / 3 : (screenWidth - 48) / 2
        
        let columns = UIDevice.current.userInterfaceIdiom == .pad ? [
            GridItem(.fixed(itemWidth)),
            GridItem(.fixed(itemWidth)),
            GridItem(.fixed(itemWidth))
        ] : [
            GridItem(.fixed(itemWidth)),
            GridItem(.fixed(itemWidth))
        ]
        
        LazyVGrid(columns: columns, spacing: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16) {
            ForEach(styles) { style in
                StyleCard(style: style, isSelected: selectedStyle?.id == style.id)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedStyle = style
                        }
                    }
            }
        }
        .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 24 : 16)
    }
}

private struct StyleCard: View {
    let style: DesignStyle
    let isSelected: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private var itemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return UIDevice.current.userInterfaceIdiom == .pad ? (screenWidth - 80) / 3 : (screenWidth - 48) / 2
    }
    
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
                
                VStack(spacing: 0) {
                    Text(style.localizedName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? Color.orange : Constants.Colors.textPrimary)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
            }
            .frame(width: itemWidth - (UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8))
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
