import SwiftUI
import RevenueCat

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: FirebaseAuthService
    @EnvironmentObject var purchases: RevenueCatService
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .system
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(spacing: 12) {
                        ProBadgeView()
                        Spacer()
                        Text(purchases.isPro ? "Aktif" : "Pasif")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(purchases.isPro ? .green : .secondary)
                    }
                    Button {
                        // Paywall aç
                        dismiss()
                        // Basit yaklaşım: ana tabdan açılmıyorsa, modal sunumu üst seviye view üzerinden yapılmalı.
                        // Burada doğrudan Settings içerisinden sunuyoruz.
                    } label: {
                        NavigationLink(destination: PaywallView(purchasesService: purchases)) {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                Text("Premium'a Geç")
                            }
                        }
                    }
                } header: {
                    Text("Premium")
                        .textCase(.uppercase)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Section {
                    ForEach([Theme.light, .dark, .system], id: \.self) { theme in
                        Button {
                            withAnimation {
                                selectedTheme = theme
                                updateAppTheme(to: theme)
                            }
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: theme.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedTheme == theme ? .white : .primary)
                                    .frame(width: 32, height: 32)
                                    .background(selectedTheme == theme ? Color.black : Color.clear)
                                    .clipShape(Circle())
                                
                                Text(theme.text)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedTheme == theme {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(theme == .dark ? .gray : .black)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Appearance")
                        .textCase(.uppercase)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
                
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
                
                Section {
                    if authService.isAuthenticated {
                        Button {
                            authService.signOut()
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                                Text("Sign Out")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                } header: {
                    Text("Account")
                        .textCase(.uppercase)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
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
        }
    }
    
    private func updateAppTheme(to theme: Theme) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        switch theme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        case .system:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
}
