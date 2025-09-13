import SwiftUI

struct ContactSection: View {
    @StateObject private var languageManager = LanguageManager.shared
    var body: some View {
        Section {
            NavigationLink(destination: Text("contact_us".localized(with: languageManager.languageUpdateTrigger))) {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.primary)
                    Text("contact_us".localized(with: languageManager.languageUpdateTrigger))
                }
            }
        } header: {
            Text("contact_us".localized(with: languageManager.languageUpdateTrigger))
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
