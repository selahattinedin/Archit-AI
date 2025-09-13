import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var authService: FirebaseAuthService
    @State private var selectedDesign: Design?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var languageManager = LanguageManager.shared
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var isTablet: Bool {
        horizontalSizeClass == .regular && isIPad
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            Group {
                if homeViewModel.isLoading {
                    VStack(spacing: isTablet ? 40 : 24) {
                        Spacer()
                        
                        VStack(spacing: isTablet ? 24 : 16) {
                            ProgressView()
                                .scaleEffect(isTablet ? 2.5 : 1.8)
                            
                            Text("loading_designs".localized(with: languageManager.languageUpdateTrigger))
                                .font(.system(size: isTablet ? 24 : 18))
                                .foregroundColor(Constants.Colors.textSecondary)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, isTablet ? 40 : 20)
                    .padding(.vertical, isTablet ? 60 : 40)
                } else if let errorMessage = homeViewModel.errorMessage {
                    VStack(spacing: isTablet ? 40 : 24) {
                        Spacer()
                        
                        VStack(spacing: isTablet ? 24 : 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: isTablet ? 120 : 80))
                                .foregroundColor(.red)
                                .opacity(0.8)
                            
                            VStack(spacing: isTablet ? 16 : 12) {
                                Text("error_occurred".localized(with: languageManager.languageUpdateTrigger))
                                    .font(.system(size: isTablet ? 32 : 24, weight: .semibold))
                                    .foregroundColor(Constants.Colors.textPrimary)
                                
                                Text(errorMessage)
                                    .font(.system(size: isTablet ? 22 : 18))
                                    .foregroundColor(Constants.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, isTablet ? 60 : 30)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, isTablet ? 40 : 20)
                    .padding(.vertical, isTablet ? 60 : 40)
                } else if homeViewModel.designs.isEmpty {
                    VStack(spacing: isTablet ? 40 : 24) {
                        Spacer()
                        
                        VStack(spacing: isTablet ? 24 : 16) {
                            Image(systemName: "photo.stack")
                                .font(.system(size: isTablet ? 120 : 80))
                                .foregroundColor(.gray)
                                .opacity(0.8)
                            
                            VStack(spacing: isTablet ? 16 : 12) {
                                Text("no_designs".localized(with: languageManager.languageUpdateTrigger))
                                    .font(.system(size: isTablet ? 32 : 24, weight: .semibold))
                                    .foregroundColor(Constants.Colors.textPrimary)
                                
                                Text("create_first_design".localized(with: languageManager.languageUpdateTrigger))
                                    .font(.system(size: isTablet ? 22 : 18))
                                    .foregroundColor(Constants.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, isTablet ? 60 : 30)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, isTablet ? 40 : 20)
                    .padding(.vertical, isTablet ? 60 : 40)
                    .onAppear {
                        print("📱 Empty state showing - designs count: \(homeViewModel.designs.count)")
                        print("📱 isTablet: \(isTablet)")
                        print("📱 isIPad: \(isIPad)")
                        print("📱 horizontalSizeClass: \(horizontalSizeClass)")
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(homeViewModel.designs) { design in
                                DesignHistoryCard(design: design)
                                    .onTapGesture {
                                        selectedDesign = design
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                homeViewModel.removeDesign(design)
                                            }
                                        } label: {
                                            Label("delete".localized(with: languageManager.languageUpdateTrigger), systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                    .refreshable {
                        if let userID = authService.currentUserId {
                            await homeViewModel.loadDesignsFromFirebase(userID: userID)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("history".localized(with: languageManager.languageUpdateTrigger))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Constants.Colors.textPrimary)
            }
        }
        .fullScreenCover(item: $selectedDesign) { design in
            DesignDetailView(
                design: design,
                isFromCreate: false,
                onSave: nil,
                onClose: nil
            )
            .environmentObject(homeViewModel)
        }
        .onAppear {
            selectedDesign = nil
            // Otomatik yenileme
            if let userID = authService.currentUserId {
                Task {
                    await homeViewModel.loadDesignsFromFirebase(userID: userID)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .init("DesignCreated"))) { _ in
            // Yeni tasarım oluşturulduğunda otomatik yenile
            if let userID = authService.currentUserId {
                Task {
                    await homeViewModel.loadDesignsFromFirebase(userID: userID)
                }
            }
        }
    }
    
    struct DesignHistoryCard: View {
        let design: Design
        @Environment(\.colorScheme) var colorScheme
        @StateObject private var imageLoader = AsyncImageLoader()
        @StateObject private var languageManager = LanguageManager.shared
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Constants.Colors.cardBackground)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: design.room.icon)
                            .font(.system(size: 18))
                            .foregroundColor(Constants.Colors.textPrimary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(design.room.localizedName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Constants.Colors.textPrimary)
                        
                        Text(design.style.localizedName)
                            .font(.system(size: 14))
                            .foregroundColor(Constants.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(timeAgo(from: design.createdAt))
                        .font(.system(size: 13))
                        .foregroundColor(Constants.Colors.textSecondary)
                }
                
                HStack(spacing: 12) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("before".localized(with: languageManager.languageUpdateTrigger))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(colorScheme == .dark ? .gray : Constants.Colors.textSecondary)
                        
                        Group {
                            if let image = design.beforeImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if let url = design.beforeImageURL, !url.isEmpty {
                                AsyncImageView(
                                    url: url,
                                    cache: imageLoader.cache
                                )
                            } else {
                                ZStack {
                                    Rectangle().fill(Color.gray.opacity(0.2))
                                    Image(systemName: "photo").foregroundColor(.gray)
                                }
                            }
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Constants.Colors.cardBorder, lineWidth: 1)
                            
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("after".localized(with: languageManager.languageUpdateTrigger))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(colorScheme == .dark ? .gray : Constants.Colors.textSecondary)
                        
                        Group {
                            if let image = design.afterImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if let url = design.afterImageURL, !url.isEmpty {
                                AsyncImageView(
                                    url: url,
                                    cache: imageLoader.cache
                                )
                            } else {
                                ZStack {
                                    Rectangle().fill(Color.gray.opacity(0.2))
                                    Image(systemName: "photo").foregroundColor(.gray)
                                }
                            }
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Constants.Colors.cardBorder, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(20)
            .background(Constants.Colors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Constants.Colors.cardBorder, lineWidth: 1)
            )
            .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.08), radius: 15, x: 0, y: 5)
        }
        
        private func timeAgo(from date: Date) -> String {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
            
            let language = LanguageManager.shared.selectedLanguage
            
            let formatTime: (Int, String, String) -> String = { value, singular, plural in
                let unit = value == 1 ? singular : plural.replacingOccurrences(of: "_", with: " ")
                if language == .turkish {
                    return "\(value) \(unit) \("ago".localized(with: languageManager.languageUpdateTrigger))"
                } else {
                    return "\(value) \(unit) \("ago".localized(with: languageManager.languageUpdateTrigger))"
                }
            }
            
            if let years = components.year, years > 0 {
                return formatTime(years, "year".localized(with: languageManager.languageUpdateTrigger), "years".localized(with: languageManager.languageUpdateTrigger))
            }
            if let months = components.month, months > 0 {
                return formatTime(months, "month".localized(with: languageManager.languageUpdateTrigger), "months".localized(with: languageManager.languageUpdateTrigger))
            }
            if let days = components.day, days >= 7 {
                let weeks = days / 7
                return formatTime(weeks, "week".localized(with: languageManager.languageUpdateTrigger), "weeks".localized(with: languageManager.languageUpdateTrigger))
            }
            if let days = components.day, days > 0 {
                return formatTime(days, "day".localized(with: languageManager.languageUpdateTrigger), "days".localized(with: languageManager.languageUpdateTrigger))
            }
            if let hours = components.hour, hours > 0 {
                return formatTime(hours, "hour".localized(with: languageManager.languageUpdateTrigger), "hours".localized(with: languageManager.languageUpdateTrigger))
            }
            if let minutes = components.minute, minutes > 0 {
                return formatTime(minutes, "minute".localized(with: languageManager.languageUpdateTrigger), "minutes".localized(with: languageManager.languageUpdateTrigger))
            }
            return formatTime(1, "minute".localized(with: languageManager.languageUpdateTrigger), "minutes".localized(with: languageManager.languageUpdateTrigger))
        }
    }
    
}
