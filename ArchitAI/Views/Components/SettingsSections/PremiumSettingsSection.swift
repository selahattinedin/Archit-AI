import SwiftUI

struct PremiumSettingsSection: View {
    @EnvironmentObject var purchases: RevenueCatService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Section {
            HStack(spacing: 12) {
                ProBadgeView()
                Spacer()
                Text(purchases.isPro ? "Active" : "Inactive")
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
                        Text("Upgrade to Premium")
                    }
                }
            }
        } header: {
            Text("Premium")
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
