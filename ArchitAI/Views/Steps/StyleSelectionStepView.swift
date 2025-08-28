import SwiftUI

struct StyleSelectionStepView: View {
    @Binding var selectedStyle: DesignStyle?
    let styles: [DesignStyle]
    let isLoading: Bool
    let onGenerate: () -> Void
    let error: Error?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack {
                    StyleSelectionView(styles: styles, selectedStyle: $selectedStyle)
                        .padding()
                        .padding(.top, 1)
                    
                    if let error = error {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }
                    
                    // Extra space for button
                    Color.clear
                        .frame(height: 80)
                }
            }
            
            // Fixed Button at bottom
            VStack(spacing: 0) {
                Button(action: onGenerate) {
                    HStack(spacing: 12) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .dark ? .black : .white))
                        } else {
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                        Text(isLoading ? "Generating..." : "Transform Room")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(height: 46)
                    .frame(maxWidth: .infinity)
                    .background(selectedStyle != nil ? (colorScheme == .dark ? Color.white : Color.black) : Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(selectedStyle == nil || isLoading)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .padding(.bottom, 8)
            }
            .background(Constants.Colors.cardBackground)
        }
    }
}