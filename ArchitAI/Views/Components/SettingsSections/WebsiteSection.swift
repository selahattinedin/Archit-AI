import SwiftUI

struct WebsiteSection: View {
    var body: some View {
        Section {
            Link(destination: URL(string: "https://architai.app")!) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.primary)
                    Text("Website")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.primary)
                        .font(.system(size: 14))
                }
            }
        } header: {
            Text("Website")
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
