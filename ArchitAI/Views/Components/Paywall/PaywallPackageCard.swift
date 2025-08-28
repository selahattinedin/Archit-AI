import SwiftUI
import RevenueCat

struct PaywallPackageCard: View {
    let package: Package
    let isSelected: Bool
    let title: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Selection Indicator
                ZStack {
                    Circle()
                        .fill(isSelected ? Constants.Colors.PremiumOrange : Color.clear)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Constants.Colors.PremiumOrange : Color.white.opacity(0.3), lineWidth: 2)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Package Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(package.storeProduct.localizedTitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Price
                VStack(alignment: .trailing, spacing: 2) {
                    Text(package.storeProduct.localizedPriceString)
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(Constants.Colors.PremiumOrange)
                    
                    if package.packageType == .annual {
                        Text("Best Value")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Constants.Colors.PremiumOrange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Constants.Colors.PremiumOrange.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Constants.Colors.PremiumOrange : Color.white.opacity(0.2),
                        lineWidth: isSelected ? 3 : 1.5
                    )
            )
            .shadow(
                color: isSelected ? Constants.Colors.PremiumOrange.opacity(0.3) : Color.clear,
                radius: isSelected ? 12 : 0,
                x: 0,
                y: isSelected ? 6 : 0
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
            .padding(.horizontal, 24)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    Text("PaywallPackageCard Preview")
        .background(Color.black)
        .padding()
}
