import SwiftUI
import RevenueCat

struct PaywallContinueButton: View {
    let package: Package
    @ObservedObject var viewModel: PaywallViewModel
    
    var body: some View {
        Button(action: { viewModel.purchaseSelectedPackage() }) {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                // Text
                Text("Continue with \(viewModel.packageTitle(for: package))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Constants.Colors.PremiumOrange,
                        Constants.Colors.PremiumOrange.opacity(0.8)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Constants.Colors.PremiumOrange.opacity(0.3), lineWidth: 1)
            )
            .shadow(
                color: Constants.Colors.PremiumOrange.opacity(0.4),
                radius: 12,
                x: 0,
                y: 6
            )
        }
        .disabled(viewModel.selectedPackage == nil)
        .opacity(viewModel.selectedPackage != nil ? 1.0 : 0.6)
        .scaleEffect(viewModel.selectedPackage != nil ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedPackage != nil)
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
}

#Preview {
    Text("PaywallContinueButton Preview")
        .background(Color.black)
        .padding()
}
