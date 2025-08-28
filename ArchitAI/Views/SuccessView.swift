import SwiftUI

struct SuccessView: View {
    @Environment(\.dismiss) private var dismiss
    let design: Design
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.black)
                .padding(.top, 40)
            
            Text("Design Generated!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your design has been successfully created and saved to history.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                if let beforeImage = design.beforeImage {
                    Image(uiImage: beforeImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 200)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                
                if let afterImage = design.afterImage {
                    Image(uiImage: afterImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 200)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(28)
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
    }
}
