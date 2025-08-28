import SwiftUI

struct PaywallPackagesSection: View {
    @ObservedObject var viewModel: PaywallViewModel
    
    var body: some View {
        if viewModel.isLoading && viewModel.currentOfferings == nil {
            PaywallLoadingView()
        } else if viewModel.hasOfferings, let current = viewModel.currentOfferings?.current {
            PaywallPackagesList(offering: current, viewModel: viewModel)
        } else {
            PaywallNoOffersView(viewModel: viewModel)
        }
    }
}

#Preview {
    PaywallPackagesSection(viewModel: PaywallViewModel(purchasesService: RevenueCatService.shared))
        .background(Color.black)
}
