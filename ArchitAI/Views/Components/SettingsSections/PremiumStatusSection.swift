import SwiftUI

struct PremiumStatusSection: View {
    @EnvironmentObject var purchases: RevenueCatService
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        Section {
            HStack {
                HStack(spacing: 8) {
                    Text("premium".localized(with: languageManager.languageUpdateTrigger))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("PremiumOrange"))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    
                    Spacer()
                }
                
                Spacer()
                
                Text(purchases.isPro ? 
                     "premium_status_active".localized(with: languageManager.languageUpdateTrigger) : 
                     "premium_status_inactive".localized(with: languageManager.languageUpdateTrigger))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(purchases.isPro ? .green : .secondary)
            }
        }
    }
}
