import SwiftUI

struct WebsiteSection: View {
    @StateObject private var languageManager = LanguageManager.shared
    var body: some View {
        Section {
            Link(destination: URL(string: "https://architai.app")!) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundColor(.primary)
                    Text("website".localized(with: languageManager.languageUpdateTrigger))
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.primary)
                        .font(.system(size: 14))
                }
            }
        } header: {
            Text("website".localized(with: languageManager.languageUpdateTrigger))
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
        }
    }
}
