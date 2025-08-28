import SwiftUI

struct PaywallFeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Constants.Colors.PremiumOrange)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}

#Preview {
    PaywallFeatureRow(
        icon: "sparkles",
        title: "Unlimited designs",
        subtitle: "Create as many designs as you want without restrictions"
    )
    .background(Color.black)
    .padding()
}
