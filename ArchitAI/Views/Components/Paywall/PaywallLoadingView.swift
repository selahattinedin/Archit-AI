import SwiftUI

struct PaywallLoadingView: View {
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(Constants.Colors.PremiumRed)
            Text("loading_offers".localized(with: languageManager.languageUpdateTrigger))
                .foregroundColor(.gray)
        }
        .padding(.top, 10)
    }
}

#Preview {
    PaywallLoadingView()
        .background(Color.black)
}
