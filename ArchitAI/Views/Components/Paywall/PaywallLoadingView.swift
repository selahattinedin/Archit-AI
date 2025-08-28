import SwiftUI

struct PaywallLoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(Constants.Colors.PremiumOrange)
            Text("Loading offers...")
                .foregroundColor(.gray)
        }
        .padding(.top, 10)
    }
}

#Preview {
    PaywallLoadingView()
        .background(Color.black)
}
