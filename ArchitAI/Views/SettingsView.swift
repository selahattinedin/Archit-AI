import SwiftUI
import RevenueCat

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: FirebaseAuthService
    @EnvironmentObject var purchases: RevenueCatService
    @State private var showDeleteAccountAlert = false
    @State private var showDeleteError = false
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationView {
            List {
                PremiumStatusSection()
                AppearanceSettingsSection()
                LanguageSettingsSection()
                LegalSection()
                WebsiteSection()
                ContactSection()
                
                AccountSettingsSection(showDeleteAccountAlert: $showDeleteAccountAlert,
                                    showDeleteError: $showDeleteError)
            }
            .navigationTitle("settings".localized(with: languageManager.languageUpdateTrigger))
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
            .alert("delete_account".localized(with: languageManager.languageUpdateTrigger), isPresented: $showDeleteAccountAlert) {
                Button("cancel".localized(with: languageManager.languageUpdateTrigger), role: .cancel) {}
                Button("delete".localized(with: languageManager.languageUpdateTrigger), role: .destructive) {
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
                Text("delete_account_message".localized(with: languageManager.languageUpdateTrigger))
            }
            .alert("error".localized(with: languageManager.languageUpdateTrigger), isPresented: $showDeleteError) {
                Button("done".localized(with: languageManager.languageUpdateTrigger), role: .cancel) {}
            } message: {
                Text("delete_account_error".localized(with: languageManager.languageUpdateTrigger))
            }
        }
    }
}