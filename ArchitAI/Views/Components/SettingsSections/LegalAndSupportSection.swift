import SwiftUI

struct LegalAndSupportSection: View {
    var body: some View {
        Section {
            NavigationLink(destination: Text("Privacy Policy")) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.blue)
                    Text("Privacy Policy")
                }
            }
            
            NavigationLink(destination: Text("Terms of Service")) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.blue)
                    Text("Terms of Service")
                }
            }
            
            NavigationLink(destination: Text("EULA")) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.blue)
                    Text("End User License Agreement")
                }
            }
            
            Link(destination: URL(string: "https://architai.app")!) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.blue)
                    Text("Website")
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.blue)
                        .font(.system(size: 14))
                }
            }
            
            NavigationLink(destination: Text("Contact Us")) {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.blue)
                    Text("Contact Us")
                }
            }
        } header: {
            Text("Legal & Support")
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
