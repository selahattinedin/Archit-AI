import SwiftUI

struct AccountSettingsSection: View {
    @EnvironmentObject var authService: FirebaseAuthService
    @Environment(\.dismiss) private var dismiss
    @Binding var showDeleteAccountAlert: Bool
    @Binding var showDeleteError: Bool
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        if authService.isAuthenticated {
            Section {
                Button {
                    showDeleteAccountAlert = true
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.minus")
                        Text("delete_account".localized(with: languageManager.languageUpdateTrigger))
                        Spacer()
                    }
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
                }
            } header: {
                Text("account".localized(with: languageManager.languageUpdateTrigger))
                    .textCase(.uppercase)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
}
