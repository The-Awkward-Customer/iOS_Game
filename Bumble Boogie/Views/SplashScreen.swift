import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
//    @State private var hasStartedMusic = false
    
    var body: some View {
        if isActive {
            ContentView()
                .transition(.asymmetric(
                    insertion: .opacity,
                    removal: .opacity.combined(with: .scale)
                ))
        } else {
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.31, green: 0.04, blue: 0.58), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.53, green: 0.11, blue: 0.71), location: 0.20),
                        Gradient.Stop(color: Color(red: 1, green: 0.41, blue: 0.33), location: 0.40),
                        Gradient.Stop(color: Color(red: 1, green: 0.68, blue: 0.24), location: 0.60),
                        Gradient.Stop(color: Color(red: 0.98, green: 0.82, blue: 0.65), location: 0.80),
                        Gradient.Stop(color: Color(red: 1, green: 0.92, blue: 0.8), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    VStack(spacing: 15) {
                        Image("honeyIcon")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                        
                        Text("BumbleBoogie")
                            .font(.custom("JetBrainsMono-Bold", size: 42))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 1.0
                            self.opacity = 1.0
                        }
                    }
                    
                    // Loading indicator
                    LoadingHoneycomb()
                        .opacity(opacity)
                }
                }
                .onAppear {
                    // Start background music as splash screen appears
        
                    
                    // After a delay, transition to the main game
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
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
        .environmentObject(GameState())
}
