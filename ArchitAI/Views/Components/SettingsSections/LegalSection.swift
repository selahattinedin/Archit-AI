import SwiftUI

struct LegalSection: View {
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        Section {
            Button(action: {
                openURL("https://architai.vercel.app/privacy-policy")
            }) {
                HStack {
                    Image(systemName: "hand.raised.fill")
                        .foregroundColor(.blue)
                    Text("privacy_policy".localized(with: languageManager.languageUpdateTrigger))
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                openURL("https://architai.vercel.app/terms-of-service")
            }) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.green)
                    Text("terms_of_service".localized(with: languageManager.languageUpdateTrigger))
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                openURL("https://architai.vercel.app/terms-of-use")
            }) {
                HStack {
                    Image(systemName: "scroll.fill")
                        .foregroundColor(.orange)
                    Text("terms_of_use".localized(with: languageManager.languageUpdateTrigger))
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                }
            }
            .buttonStyle(PlainButtonStyle())
        } header: {
            Text("legal".localized(with: languageManager.languageUpdateTrigger))
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
