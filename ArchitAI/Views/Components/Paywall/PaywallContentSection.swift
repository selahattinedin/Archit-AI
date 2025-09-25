import SwiftUI

struct PaywallContentSection: View {
    @ObservedObject var viewModel: PaywallViewModel
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Features section completely removed
                PaywallPackagesSection(viewModel: viewModel)
                
                // Continue butonu her zaman görünür olsun
                if let selectedPackage = viewModel.selectedPackage {
                    PaywallContinueButton(package: selectedPackage, viewModel: viewModel)
                    // Continue altı linkler
                    HStack {
                        Button(action: { openURL("https://architai.vercel.app/privacy-policy") }) {
                            Text("privacy_policy".localized(with: languageManager.languageUpdateTrigger))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: { viewModel.restorePurchases() }) {
                            Text("restore_purchases".localized(with: languageManager.languageUpdateTrigger))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: { openURL("https://architai.vercel.app/terms-of-service") }) {
                            Text("terms_of_service".localized(with: languageManager.languageUpdateTrigger))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                } else {
                    // Eğer henüz paket seçilmemişse, placeholder continue butonu göster
                    Button(action: {}) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("continue_with_annual".localized(with: languageManager.languageUpdateTrigger))
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
                        .background(Constants.Colors.PremiumRed.opacity(0.3))
                        .cornerRadius(20)
                    }
                    .disabled(true)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    HStack {
                        Button(action: { openURL("https://architai.vercel.app/privacy-policy") }) {
                            Text("privacy_policy".localized(with: languageManager.languageUpdateTrigger))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                        Button(action: { viewModel.restorePurchases() }) {
                            Text("restore_purchases".localized(with: languageManager.languageUpdateTrigger))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Spacer()
                        Button(action: { openURL("https://architai.vercel.app/terms-of-service") }) {
                            Text("terms_of_service".localized(with: languageManager.languageUpdateTrigger))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
                
                Spacer(minLength: 24)
            }
        }
        .background(Color.clear)
    }
}

#if canImport(UIKit)
private func openURL(_ urlString: String) {
    guard let url = URL(string: urlString) else { return }
    UIApplication.shared.open(url)
}
#endif

#Preview {
    PaywallContentSection(viewModel: PaywallViewModel(purchasesService: RevenueCatService.shared))
        .background(Color.black)
}
