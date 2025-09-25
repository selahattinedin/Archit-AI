import SwiftUI
import RevenueCat

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: FirebaseAuthService
    @EnvironmentObject var purchases: RevenueCatService
    @State private var showDeleteAccountAlert = false
    @State private var showDeleteError = false
    @State private var showPaywall = false
    @StateObject private var languageManager = LanguageManager.shared
    
    
    var body: some View {
        NavigationView {
            List {
                // Premium ve Dil kısımları değişmeden kalsın
                PremiumStatusSection(onTap: { showPaywall = true })
                LanguageSettingsSection()
                AppearanceSettingsSection()

                // Tek liste satırları (görseldeki gibi) — tek kart içinde gruplandı
                Section {
                    SettingsRow(title: "website".localized(with: languageManager.languageUpdateTrigger), icon: "globe") {
                        openURL("https://architai.vercel.app")
                    }
                    SettingsRow(title: "terms_of_service".localized(with: languageManager.languageUpdateTrigger), icon: "doc.text.fill") {
                        openURL("https://architai.vercel.app/terms-of-service")
                    }
                    SettingsRow(title: "terms_of_use".localized(with: languageManager.languageUpdateTrigger), icon: "scroll.fill") {
                        openURL("https://architai.vercel.app/eula")
                    }
                    SettingsRow(title: "privacy_policy".localized(with: languageManager.languageUpdateTrigger), icon: "shield.fill") {
                        openURL("https://architai.vercel.app/privacy-policy")
                    }
                    SettingsRow(title: "restore_purchases".localized(with: languageManager.languageUpdateTrigger), icon: "arrow.counterclockwise") {
                        purchases.restorePurchases()
                    }
                    UserIdRow(userId: authService.currentUserId ?? "-")
                }
                // Hesabı Sil: Ayrı bölüm
                AccountSettingsSection(showDeleteAccountAlert: $showDeleteAccountAlert,
                                       showDeleteError: $showDeleteError)

                VersionFooter()
            }
            .fullScreenCover(isPresented: $showPaywall) {
                PaywallView(purchasesService: purchases)
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
            .onAppear {
                // Premium durumu güncel olsun
                purchases.refreshCustomerInfo()
            }
            .alert("delete_account".localized(with: languageManager.languageUpdateTrigger), isPresented: $showDeleteAccountAlert) {
                Button("cancel".localized(with: languageManager.languageUpdateTrigger), role: .cancel) {}
                Button("delete".localized(with: languageManager.languageUpdateTrigger), role: .destructive) {
                    Task {
                        do {
                            try await authService.deleteAccount()
                            // Ekranı kapatma, buton görünür kalsın
                            purchases.refreshCustomerInfo()
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

// MARK: - Helpers & Rows

private struct SettingsRow: View {
    let title: String
    let icon: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct UserIdRow: View {
    let userId: String
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.fill")
                .font(.system(size: 20))
            Text("user_id".localized)
                .foregroundColor(.primary)
            Spacer()
            Text(userId)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(1)
                .truncationMode(.middle)
                .foregroundColor(.secondary)
            Button(action: { UIPasteboard.general.string = userId }) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

private struct VersionFooter: View {
    var body: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        HStack { Spacer() }
            .listRowBackground(Color.clear)
            .overlay(
                VStack(alignment: .center) {
                    Spacer(minLength: 8)
                    Text("Version \(version)")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            )
    }
}

private func openURL(_ urlString: String) {
    guard let url = URL(string: urlString) else { return }
    UIApplication.shared.open(url)
}

import StoreKit
private func requestReview() {
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        SKStoreReviewController.requestReview(in: scene)
    }
}

private struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}