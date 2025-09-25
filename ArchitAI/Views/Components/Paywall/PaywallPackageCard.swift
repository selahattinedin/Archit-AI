import SwiftUI
import RevenueCat

struct PaywallPackageCard: View {
    let package: Package
    let isSelected: Bool
    let title: String
    let onTap: () -> Void
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
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
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(
                        {
                            switch package.packageType {
                            case .annual:
                                return "paywall_subtitle_annual".localized(with: languageManager.languageUpdateTrigger)
                            case .weekly:
                                return "paywall_subtitle_weekly".localized(with: languageManager.languageUpdateTrigger)
                            default:
                                return package.storeProduct.localizedTitle
                            }
                        }()
                    )
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Price
                VStack(alignment: .trailing, spacing: 0) {
                    Text(package.storeProduct.localizedPriceString)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.white)
                    
                    if package.packageType == .annual {
                        Text("best_value".localized(with: languageManager.languageUpdateTrigger))
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Constants.Colors.PremiumRed)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 1)
                            .background(Constants.Colors.PremiumRed.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color.white : Color.white.opacity(0.2),
                        lineWidth: isSelected ? 1.8 : 1.2
                    )
            )
            .shadow(
                color: isSelected ? Color.white.opacity(0.25) : Color.clear,
                radius: isSelected ? 10 : 0,
                x: 0,
                y: isSelected ? 5 : 0
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
