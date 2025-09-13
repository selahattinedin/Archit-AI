import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        if isActive {
            MainTabView()
        } else {
            ZStack {
                Color("PremiumOrange")
                    .opacity(0.1)
                    .ignoresSafeArea()
                
                VStack {
                    Image("icon_image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .cornerRadius(25)
                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    Text("archit ai")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.top, 20)
                        .opacity(opacity)
                    
                    // Centered and shortened loading bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: geometry.size.width * 0.6, height: 3)
                                .opacity(0.3)
                                .foregroundColor(.gray)
                            
                            Rectangle()
                                .frame(width: geometry.size.width * 0.6 * progress, height: 3)
                                .foregroundColor(Color("PremiumOrange"))
                        }
                        .cornerRadius(1.5)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(height: 3)
                    .padding(.top, 20)
                }
            }
            .preferredColorScheme(.light)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 1.0
                    self.opacity = 1.0
                }
                
                // Animate progress bar
                withAnimation(.linear(duration: 1.8)) {
                    self.progress = 1.0
                }
                
                // Navigate to main view after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
