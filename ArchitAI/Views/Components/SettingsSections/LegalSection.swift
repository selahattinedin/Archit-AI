import SwiftUI

struct LegalSection: View {
    @StateObject private var languageManager = LanguageManager.shared
    var body: some View {
        Section {
            NavigationLink(destination: Text("privacy_policy".localized(with: languageManager.languageUpdateTrigger))) {
                HStack {
                    Image(systemName: "hand.raised.fill")
                        .foregroundColor(.blue)
                    Text("privacy_policy".localized(with: languageManager.languageUpdateTrigger))
                }
            }
            
            NavigationLink(destination: Text("terms_of_service".localized(with: languageManager.languageUpdateTrigger))) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.green)
                    Text("terms_of_service".localized(with: languageManager.languageUpdateTrigger))
                }
            }
            
            NavigationLink(destination: Text("terms_of_use".localized(with: languageManager.languageUpdateTrigger))) {
                HStack {
                    Image(systemName: "scroll.fill")
                        .foregroundColor(.orange)
                    Text("terms_of_use".localized(with: languageManager.languageUpdateTrigger))
                }
            }
        } header: {
            Text("legal".localized(with: languageManager.languageUpdateTrigger))
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
