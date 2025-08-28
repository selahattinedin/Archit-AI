import SwiftUI

struct PaywallNoOffersView: View {
    @ObservedObject var viewModel: PaywallViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("No offers available at the moment.")
                .foregroundColor(.white)
            Button("Refresh") { viewModel.refreshOfferings() }
                .foregroundColor(Constants.Colors.PremiumOrange)
        }
        .padding(.top, 10)
    }
}

#Preview {
    PaywallNoOffersView(viewModel: PaywallViewModel(purchasesService: RevenueCatService.shared))
        .background(Color.black)
}
