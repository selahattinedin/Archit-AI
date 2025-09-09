import SwiftUI

struct AccountSettingsSection: View {
    @EnvironmentObject var authService: FirebaseAuthService
    @Environment(\.dismiss) private var dismiss
    @Binding var showDeleteAccountAlert: Bool
    @Binding var showDeleteError: Bool
    
    var body: some View {
        if authService.isAuthenticated {
            Section {
                Button {
                    showDeleteAccountAlert = true
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.minus")
                        Text("Delete Account")
                        Spacer()
                    }
                    .foregroundColor(.red)
                    .padding(.vertical, 8)
                }
            } header: {
                Text("Account")
                    .textCase(.uppercase)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
}
