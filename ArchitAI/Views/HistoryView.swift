import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var authService: FirebaseAuthService
    @State private var selectedDesign: Design?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            Group {
                if homeViewModel.isLoading {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Tasarımlar yükleniyor...")
                            .font(.system(size: 16))
                            .foregroundColor(Constants.Colors.textSecondary)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else if let errorMessage = homeViewModel.errorMessage {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 64))
                            .foregroundColor(.red)
                        
                        VStack(spacing: 8) {
                            Text("Bir hata oluştu")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Constants.Colors.textPrimary)
                            
                            Text(errorMessage)
                                .font(.system(size: 16))
                                .foregroundColor(Constants.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else if homeViewModel.designs.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "photo.stack")
                            .font(.system(size: 64))
                            .foregroundColor(Constants.Colors.textSecondary)
                        
                        VStack(spacing: 8) {
                            Text("Henüz bir tasarım eklemediniz")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Constants.Colors.textPrimary)
                            
                            Text("İlk tasarımınızı oluşturmak için Create sekmesine gidin")
                                .font(.system(size: 16))
                                .foregroundColor(Constants.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
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
                                            Label("Delete", systemImage: "trash")
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
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("History")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Constants.Colors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let userID = authService.currentUserId {
                            Task {
                                await homeViewModel.loadDesignsFromFirebase(userID: userID)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Constants.Colors.textPrimary)
                    }
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
        }
        .onAppear {
            selectedDesign = nil
        }
    }
}

struct DesignHistoryCard: View {
    let design: Design
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var imageLoader = AsyncImageLoader()
    
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
                    Text(design.room.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Constants.Colors.textPrimary)
                    
                    Text(design.style.name)
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
                    Text("Before")
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
                    Text("After")
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
        .shadow(color: colorScheme == .dark ? .clear : .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    HistoryView()
        .environmentObject(HomeViewModel())
        .environmentObject(FirebaseAuthService())
}
