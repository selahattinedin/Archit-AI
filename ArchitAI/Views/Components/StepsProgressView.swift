import SwiftUI

struct StepsProgressView: View {
    let currentStep: Int
    private let totalSteps = 4
    private let steps = ["Upload Photo", "Select Room", "Choose Style", "Generate"]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            // Step counter
            Text("Step \(currentStep + 1)/\(totalSteps)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Constants.Colors.textPrimary)
            
            HStack(spacing: 8) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    Rectangle()
                        .fill(index <= currentStep ?
                              (colorScheme == .dark ? Color.white : Color.black) :
                              Color.gray.opacity(0.2))
                        .frame(height: 4)
                        .cornerRadius(2)
                }
            }
            .padding(.horizontal, 24)
            
            HStack {
                Text(steps[currentStep])
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Constants.Colors.textSecondary)
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}
