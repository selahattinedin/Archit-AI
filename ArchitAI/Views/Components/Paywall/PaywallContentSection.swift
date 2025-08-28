import SwiftUI

struct PaywallContentSection: View {
    @ObservedObject var viewModel: PaywallViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Features section completely removed
                PaywallPackagesSection(viewModel: viewModel)
                
                // Continue butonu her zaman görünür olsun
                if let selectedPackage = viewModel.selectedPackage {
                    PaywallContinueButton(package: selectedPackage, viewModel: viewModel)
                } else {
                    // Eğer henüz paket seçilmemişse, placeholder continue butonu göster
                    Button(action: {}) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("Continue with Annual")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background(Constants.Colors.PremiumOrange.opacity(0.3))
                        .cornerRadius(20)
                    }
                    .disabled(true)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
                
                Spacer(minLength: 24)
            }
        }
        .background(Color.clear)
    }
}

#Preview {
    PaywallContentSection(viewModel: PaywallViewModel(purchasesService: RevenueCatService.shared))
        .background(Color.black)
}
