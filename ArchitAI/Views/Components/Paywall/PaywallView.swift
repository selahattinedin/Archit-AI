import SwiftUI

struct PaywallView: View {
    @StateObject private var viewModel: PaywallViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(purchasesService: RevenueCatService) {
        self._viewModel = StateObject(wrappedValue: PaywallViewModel(purchasesService: purchasesService))
    }
    
    var body: some View {
        ZStack {
            // Ana content
            VStack(spacing: 0) {
                PaywallHeroSection()
                PaywallContentSection(viewModel: viewModel)
            }
            .background(Color.black)
            
            // Close button overlay - En üstte
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        print("🔴 Close button tapped!")
                        dismiss()
                        print("🔴 Dismiss called")
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.6))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 24)
                    .padding(.top, 8)
                }
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchOfferings()
            print("🟢 PaywallView appeared")
            print("🟢 Dismiss environment available: \(dismiss != nil)")
        }
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            print("🟡 shouldDismiss changed to: \(shouldDismiss)")
            if shouldDismiss {
                print("🟡 Attempting to dismiss paywall...")
                dismiss()
                print("🟡 Dismiss called")
            }
        }
        .onChange(of: viewModel.isPro) { isPro in
            print("🟡 isPro changed to: \(isPro)")
            if isPro {
                print("🟡 User became Pro, dismissing paywall")
                dismiss()
                print("🟡 Dismiss called for Pro user")
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

#Preview {
    PaywallView(purchasesService: RevenueCatService.shared)
}
