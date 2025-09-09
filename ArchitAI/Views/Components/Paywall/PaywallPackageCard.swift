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
                        .fill(isSelected ? Color.white : Color.clear)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Color.white : Color.white.opacity(0.3), lineWidth: 2)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
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
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white)
                    
                    if package.packageType == .annual {
                        Text("Best Value")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Constants.Colors.PremiumRed)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Constants.Colors.PremiumRed.opacity(0.2))
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
                        isSelected ? Color.white : Color.white.opacity(0.2),
                        lineWidth: isSelected ? 2 : 1.5
                    )
            )
            .shadow(
                color: isSelected ? Color.white.opacity(0.25) : Color.clear,
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
