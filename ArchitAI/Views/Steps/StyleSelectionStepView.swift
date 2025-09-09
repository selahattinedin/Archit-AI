import SwiftUI

struct StyleSelectionStepView: View {
    @Binding var selectedStyle: DesignStyle?
    let styles: [DesignStyle]
    let isLoading: Bool
    let onGenerate: () -> Void
    let error: Error?
    @Environment(\.colorScheme) var colorScheme
    @State private var animateContent = false
    @State private var selectedIndex: Int? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Style Selection
            ScrollView(showsIndicators: false) {
                    StyleSelectionView(styles: styles, selectedStyle: $selectedStyle)
                    .padding(.bottom, 24)
            }
            
            // Error Display
            if let error = error {
                errorDisplay(error: error)
            }
        }
        .padding(.horizontal, 20)
        .safeAreaInset(edge: .bottom) {
            bottomButton
                .padding(.horizontal, 20)
                .padding(.top, 8)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateContent = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 24) {
            // Enhanced Icon with Gradient
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.purple.opacity(0.2), radius: 10, x: 0, y: 5)
                
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.purple)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .scaleEffect(animateContent ? 1.0 : 0.8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateContent)
            
            VStack(spacing: 12) {
                Text("Choose Design Style")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Constants.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Select your preferred interior design aesthetic")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Constants.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.8).delay(0.2), value: animateContent)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Style Selection Grid
    private var styleSelectionGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(Array(styles.enumerated()), id: \.offset) { index, style in
                styleCard(style: style, index: index)
            }
        }
        .padding(.top, 20)
    }
    
    private func styleCard(style: DesignStyle, index: Int) -> some View {
        let isSelected = selectedStyle?.id == style.id
        let _ = print("StyleCard \(style.name): isSelected = \(isSelected), selectedStyle = \(selectedStyle?.name ?? "nil")")
        
        return Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                if selectedStyle?.id != style.id {
                    selectedStyle = style
                    selectedIndex = index
                    Constants.Haptics.selection()
                }
            }
        } label: {
            VStack(spacing: 0) {
                // Enhanced Image Section
                ZStack {
                    Image(style.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    // Enhanced Selection Overlay
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.2)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 32, height: 32)
                                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                    
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .scaleEffect(isSelected ? 1.0 : 0.0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
                            )
                    }
                }
                
                // Content Section
                VStack(spacing: 8) {
                    Text(style.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Constants.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(style.description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Constants.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        isSelected ? 
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple.opacity(0.08), Color.blue.opacity(0.03)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Constants.Colors.cardBackground, Constants.Colors.cardBackground.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isSelected ? 
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple.opacity(0.4), Color.blue.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .shadow(
                color: isSelected ? 
                    Color.purple.opacity(0.15) : 
                    .black.opacity(0.04),
                radius: isSelected ? 15 : 8,
                x: 0,
                y: isSelected ? 8 : 4
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.03 : 1.0)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : 30)
        .animation(
            .spring(response: 0.6, dampingFraction: 0.8)
            .delay(Double(index) * 0.1),
            value: animateContent
        )
    }
    
    // MARK: - Error Display
    private func errorDisplay(error: Error) -> some View {
        HStack(spacing: 16) {
            // Enhanced Error Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.red.opacity(0.2), Color.orange.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .shadow(color: Color.red.opacity(0.2), radius: 8, x: 0, y: 4)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.red)
            }
            
            // Error Content
            VStack(alignment: .leading, spacing: 4) {
                Text("Something went wrong")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.red)
                
                Text(error.localizedDescription)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Constants.Colors.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.red.opacity(0.08), Color.orange.opacity(0.03)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red.opacity(0.3), Color.orange.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .red.opacity(0.15), radius: 15, x: 0, y: 8)
        .padding(.top, 20)
    }
    
    // MARK: - Bottom Button (used in safeAreaInset)
    private var bottomButton: some View {
        ContinueButton(
            title: isLoading ? "Generating..." : "Transform Room",
            icon: "wand.and.stars",
            isLoading: isLoading,
            isEnabled: selectedStyle != nil && !isLoading,
            action: onGenerate
        )
    }
}