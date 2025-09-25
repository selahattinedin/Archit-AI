import SwiftUI

struct PaywallNoOffersView: View {
    @ObservedObject var viewModel: PaywallViewModel
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            Text("no_offers".localized(with: languageManager.languageUpdateTrigger))
                .foregroundColor(.white)
            Button("refresh".localized(with: languageManager.languageUpdateTrigger)) { viewModel.refreshOfferings() }
                .foregroundColor(Constants.Colors.PremiumRed)
        }
        .padding(.top, 10)
    }
}

#Preview {
    PaywallNoOffersView(viewModel: PaywallViewModel(purchasesService: RevenueCatService.shared))
        .background(Color.black)
}
