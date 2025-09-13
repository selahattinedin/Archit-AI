import SwiftUI

struct PremiumSettingsSection: View {
    @EnvironmentObject var purchases: RevenueCatService
    @Environment(\.dismiss) private var dismiss
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        Section {
            HStack(spacing: 12) {
                ProBadgeView()
                Spacer()
                Text(purchases.isPro ? "premium_status_active".localized(with: languageManager.languageUpdateTrigger) : "premium_status_inactive".localized(with: languageManager.languageUpdateTrigger))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(purchases.isPro ? .green : .secondary)
            }
            Button {
                dismiss()
            } label: {
                NavigationLink(destination: PaywallView(purchasesService: purchases)) {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                        Text("upgrade_to_premium".localized(with: languageManager.languageUpdateTrigger))
                    }
                }
            }
        } header: {
            Text("premium".localized(with: languageManager.languageUpdateTrigger))
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
