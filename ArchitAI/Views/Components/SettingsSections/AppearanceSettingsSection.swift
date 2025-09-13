import SwiftUI

struct AppearanceSettingsSection: View {
    @AppStorage("selectedTheme") private var selectedTheme: Theme = .system
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
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
            Text("appearance".localized(with: languageManager.languageUpdateTrigger))
                .textCase(.uppercase)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
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
