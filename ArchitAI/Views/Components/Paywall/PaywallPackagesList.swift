import SwiftUI
import RevenueCat

struct PaywallPackagesList: View {
    let offering: Offering
    @ObservedObject var viewModel: PaywallViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.filteredPackages(from: offering), id: \.identifier) { package in
                PaywallPackageCard(
                    package: package,
                    isSelected: viewModel.selectedPackage?.identifier == package.identifier,
                    title: viewModel.packageTitle(for: package),
                    onTap: { viewModel.selectPackage(package) }
                )
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    Text("PaywallPackagesList Preview")
        .background(Color.black)
        .padding()
}
