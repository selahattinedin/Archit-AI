import SwiftUI

struct SuccessView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("design_generated".localized)
                .font(.title)
                .bold()
            
            Text("design_success_message".localized)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("done".localized)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding(24)
    }
}