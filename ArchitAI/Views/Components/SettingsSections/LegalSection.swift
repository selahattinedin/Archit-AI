import SwiftUI

struct LegalSection: View {
    var body: some View {
        Section {
            NavigationLink(destination: Text("Privacy Policy")) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.primary)
                    Text("Privacy Policy")
                }
            }
            
            NavigationLink(destination: Text("Terms of Service")) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.primary)
                    Text("Terms of Service")
                }
            }
            
            NavigationLink(destination: Text("EULA")) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.primary)
                    Text("End User License Agreement")
                }
            }
        } header: {
            Text("Legal")
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
