import SwiftUI

struct PremiumStatusSection: View {
    @EnvironmentObject var purchases: RevenueCatService
    @StateObject private var languageManager = LanguageManager.shared
    var onTap: (() -> Void)? = nil
    
    private var premiumLabel: String {
        if purchases.isPro {
            // Ürün kimliğine göre etiket (sadece haftalık / yıllık)
            switch purchases.activeProductId ?? "" {
            case let id where id.contains("week"):
                return "weekly_premium".localized(with: languageManager.languageUpdateTrigger)
            case let id where id.contains("year"):
                return "yearly_premium".localized(with: languageManager.languageUpdateTrigger)
            default:
                return "premium_active".localized(with: languageManager.languageUpdateTrigger)
            }
        } else {
            return "not_premium".localized(with: languageManager.languageUpdateTrigger)
        }
    }

    var body: some View {
        Section {
            Button { onTap?() } label: {
                HStack(spacing: 12) {
                    ProBadgeView()
                    Spacer()
                    Text(premiumLabel)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(purchases.isPro ? .green : .secondary)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .contentShape(Rectangle())
                .padding(.vertical, 4)
            }
        }
    }
}
