import SwiftUI

struct LanguageSettingsSection: View {
    @StateObject private var languageManager = LanguageManager.shared
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var isTablet: Bool {
        horizontalSizeClass == .regular
    }
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                Text("language".localized(with: languageManager.languageUpdateTrigger))
                    .textCase(.uppercase)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                
                if isTablet {
                    // Tablet için büyük horizontal scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(AppLanguage.allCases, id: \.self) { language in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(language == languageManager.selectedLanguage ? 
                                             (colorScheme == .dark ? Color.white : Color.white) : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(language == languageManager.selectedLanguage ? 
                                                       (colorScheme == .dark ? Color.black : Color.black) : Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    Button {
                                        languageManager.changeLanguage(to: language)
                                    } label: {
                                        VStack(spacing: 10) {
                                            Text(language.flagEmoji)
                                                .font(.system(size: 36))
                                            
                                            Text(language.displayName)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(language == languageManager.selectedLanguage ? 
                                                               (colorScheme == .dark ? .black : .black) : .primary)
                                                .multilineTextAlignment(.center)
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .frame(minWidth: 100)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                } else {
                    // iPhone için horizontal scroll
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(AppLanguage.allCases, id: \.self) { language in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(language == languageManager.selectedLanguage ? 
                                             (colorScheme == .dark ? Color.white : Color.white) : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(language == languageManager.selectedLanguage ? 
                                                       (colorScheme == .dark ? Color.black : Color.black) : Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    Button {
                                        languageManager.changeLanguage(to: language)
                                    } label: {
                                        VStack(spacing: 6) {
                                            Text(language.flagEmoji)
                                                .font(.system(size: 24))
                                            
                                            Text(language.displayName)
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(language == languageManager.selectedLanguage ? 
                                                               (colorScheme == .dark ? .black : .black) : .primary)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

