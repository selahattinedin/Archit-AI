import SwiftUI

struct DesignCardView: View {
    let title: String
    let subtitle: String
    let image: String
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(24)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Constants.Colors.textPrimary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(Constants.Colors.textSecondary)
                    
                    HStack {
                        Spacer()
                        Text("Try It!")
                            .font(.system(size: Constants.FontSize.body, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, Constants.Spacing.medium)
                            .padding(.vertical, Constants.Spacing.xxsmall)
                            .background(Color.black)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, Constants.Spacing.small)
                .padding(.vertical, Constants.Spacing.xsmall)
                .background(Constants.Colors.cardBackground)
            }
            .background(Constants.Colors.cardBackground)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Constants.Colors.cardBorder, lineWidth: 1)
            )
        }
    }
}