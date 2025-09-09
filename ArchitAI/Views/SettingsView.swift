import SwiftUI
import RevenueCat

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: FirebaseAuthService
    @EnvironmentObject var purchases: RevenueCatService
    @State private var showDeleteAccountAlert = false
    @State private var showDeleteError = false
    
    var body: some View {
        NavigationView {
            List {
                PremiumSettingsSection()
                AppearanceSettingsSection()
                LegalSection()
                WebsiteSection()
                ContactSection()
                
                Section {
                    HStack {
                        Text("Version")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                } header: {
                    Text("About")
                        .textCase(.uppercase)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                AccountSettingsSection(showDeleteAccountAlert: $showDeleteAccountAlert,
                                    showDeleteError: $showDeleteError)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }
            }
            .alert("Delete Account", isPresented: $showDeleteAccountAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        do {
                            try await authService.deleteAccount()
                            dismiss()
                        } catch {
                            showDeleteError = true
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }
            .alert("Error", isPresented: $showDeleteError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("An error occurred while deleting your account. Please try again later.")
            }
        }
    }
}