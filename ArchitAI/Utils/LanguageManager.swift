import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case turkish = "tr"
    case spanish = "es"
    case japanese = "ja"
    case german = "de"
    case french = "fr"
    case italian = "it"
    case russian = "ru"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .turkish: return "Türkçe"
        case .spanish: return "Español"
        case .japanese: return "日本語"
        case .german: return "Deutsch"
        case .french: return "Français"
        case .italian: return "Italiano"
        case .russian: return "Русский"
        }
    }
    
    var flagEmoji: String {
        switch self {
        case .english: return "🇬🇧"
        case .turkish: return "🇹🇷"
        case .spanish: return "🇪🇸"
        case .japanese: return "🇯🇵"
        case .german: return "🇩🇪"
        case .french: return "🇫🇷"
        case .italian: return "🇮🇹"
        case .russian: return "🇷🇺"
        }
    }
}

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var selectedLanguage: AppLanguage
    @Published var languageUpdateTrigger = UUID()
    
    private init() {
        // Profesyonel yaklaşım: Kullanıcı tercihi öncelikli
        if let savedLanguage = UserDefaults.standard.string(forKey: "app_language"),
           let language = AppLanguage(rawValue: savedLanguage) {
            // Kullanıcı daha önce dil seçmiş, onu kullan
            self.selectedLanguage = language
        } else {
            // İlk açılış, cihaz dilini kullan
            let systemLanguageCode = Locale.current.languageCode ?? "en"
            let language = AppLanguage(rawValue: systemLanguageCode) ?? .english
            self.selectedLanguage = language
            UserDefaults.standard.set(language.rawValue, forKey: "app_language")
        }
        
        // Sistem bileşenleri (örn. kamera) için dili AppleLanguages ile hizala
        UserDefaults.standard.set([selectedLanguage.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Başlangıçta dili ayarla
        print("🚀 Initializing with language: \(selectedLanguage.rawValue)")
        Bundle.setLanguage(selectedLanguage.rawValue)
    }
    
    func changeLanguage(to language: AppLanguage) {
        print("🔄 Changing language to: \(language.rawValue)")
        
        // Önce bundle'ı temizle
        Bundle.resetBundle()
        
        // Dili değiştir
        selectedLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "app_language")
        
        // Sistem bileşenlerinin (ör. UIImagePickerController) dili için AppleLanguages'i güncelle
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Bundle'ı ayarla
        Bundle.setLanguage(language.rawValue)
        
        // View'ları güncelle
        languageUpdateTrigger = UUID()
        NotificationCenter.default.post(name: .languageDidChange, object: language)
    }
    
}

// Bundle extension for localization
extension Bundle {
    fileprivate static var _bundle: Bundle?
    fileprivate static var _languageCode: String?
    
    fileprivate static func resetBundle() {
        _bundle = nil
        _languageCode = nil
    }
    
    static func setLanguage(_ language: String) {
        print("📍 setLanguage called with: \(language)")
        
        // Reset everything first
        resetBundle()
        _languageCode = language
        
        // İngilizce için en.lproj dosyasını bul
        if language == "en" {
            if let lprojPath = Bundle.main.path(forResource: "en", ofType: "lproj"),
               let lprojBundle = Bundle(path: lprojPath) {
                // Debug print removed
                _bundle = lprojBundle
            } else {
                // Debug print removed
                _bundle = Bundle.main
            }
            return
        }
        
        // Japonca için özel emoji
        if language == "ja" {
            if let lprojPath = Bundle.main.path(forResource: "ja", ofType: "lproj"),
               let lprojBundle = Bundle(path: lprojPath) {
                // Debug print removed
                _bundle = lprojBundle
            } else {
                // Debug print removed
                _bundle = Bundle.main
            }
            return
        }
        
        // Almanca için özel emoji
        if language == "de" {
            if let lprojPath = Bundle.main.path(forResource: "de", ofType: "lproj"),
               let lprojBundle = Bundle(path: lprojPath) {
                // Debug print removed
                _bundle = lprojBundle
            } else {
                // Debug print removed
                _bundle = Bundle.main
            }
            return
        }
        
        // Fransızca için özel emoji
        if language == "fr" {
            if let lprojPath = Bundle.main.path(forResource: "fr", ofType: "lproj"),
               let lprojBundle = Bundle(path: lprojPath) {
                // Debug print removed
                _bundle = lprojBundle
            } else {
                // Debug print removed
                _bundle = Bundle.main
            }
            return
        }
        
        // İtalyanca için özel emoji
        if language == "it" {
            if let lprojPath = Bundle.main.path(forResource: "it", ofType: "lproj"),
               let lprojBundle = Bundle(path: lprojPath) {
                // Debug print removed
                _bundle = lprojBundle
            } else {
                // Debug print removed
                _bundle = Bundle.main
            }
            return
        }
        
        // Rusça için özel emoji
        if language == "ru" {
            if let lprojPath = Bundle.main.path(forResource: "ru", ofType: "lproj"),
               let lprojBundle = Bundle(path: lprojPath) {
                // Debug print removed
                _bundle = lprojBundle
            } else {
                // Debug print removed
                _bundle = Bundle.main
            }
            return
        }
        
        // Diğer diller için .lproj dosyasını bul
        if let lprojPath = Bundle.main.path(forResource: language, ofType: "lproj"),
           let lprojBundle = Bundle(path: lprojPath) {
            // Debug print removed
            _bundle = lprojBundle
        } else {
            // Debug print removed
            _bundle = Bundle.main
        }
    }
    
    static func localizedBundle() -> Bundle {
        // Mevcut bundle'ı kullan
        if let bundle = _bundle {
            // Debug print removed
            return bundle
        }
        
        // Fallback olarak main bundle
        // Debug print removed
        return Bundle.main
    }
}

extension String {
    var localized: String {
        let currentLanguage = Bundle._languageCode ?? "en"
        
        // Bundle'ı doğru şekilde ayarla
        let bundle = Bundle.localizedBundle()
        
        // NSLocalizedString kullan ama doğru bundle ile
        let result = NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: "")
        
        // Eğer sonuç key ile aynıysa, fallback olarak key'i döndür
        let finalResult = result == self ? self.replacingOccurrences(of: "_", with: " ") : result
        
        // Dil için uygun emoji
        let emoji = currentLanguage == "en" ? "🇬🇧" : 
                   currentLanguage == "tr" ? "🇹🇷" : 
                   currentLanguage == "es" ? "🇪🇸" : 
                   currentLanguage == "ja" ? "🇯🇵" : 
                   currentLanguage == "de" ? "🇩🇪" : 
                   currentLanguage == "fr" ? "🇫🇷" : 
                   currentLanguage == "it" ? "🇮🇹" : 
                   currentLanguage == "ru" ? "🇷🇺" : "🌍"
        
        // Debug print removed
        return finalResult
    }
    
    func localized(with trigger: UUID) -> String {
        // trigger parameter is used just to force view updates
        return self.localized
    }
}

// Notification extension (eğer notification kullanmanız gerekiyorsa)
extension Notification.Name {
    static let languageDidChange = Notification.Name("languageDidChange")
}
