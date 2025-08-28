import SwiftUI

// Alternatif Çözüm: Closure ile
struct PaywallCloseButton: View {
    let onClose: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                print("Close button tapped!")
                onClose()
                print("onClose called")
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 20)
            .padding(.top, 20)
        }
    }
}
