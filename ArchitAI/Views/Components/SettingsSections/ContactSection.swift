import SwiftUI

struct ContactSection: View {
    var body: some View {
        Section {
            NavigationLink(destination: Text("Contact Us")) {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.primary)
                    Text("Contact Us")
                }
            }
        } header: {
            Text("Contact")
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
