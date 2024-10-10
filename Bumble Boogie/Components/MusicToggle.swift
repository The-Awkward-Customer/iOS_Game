//
//  MusicToggle.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 10/10/2024.
//

import SwiftUI

struct MusicToggle: View {
    
    //checks the value of userDefault
    @State private var isMusicPlaying = UserDefaults.standard.bool(forKey: "isMusicPlaying")
    
    
    var body: some View {
        VStack {
            Button(action: {
                isMusicPlaying.toggle()
                MusicManager.shared.toggleMusic()
                UserDefaults.standard.set(isMusicPlaying, forKey: "isMusicPlaying") // Save state
            }) {
                Image(systemName: isMusicPlaying ? "speaker.wave.3.fill" : "speaker.slash.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(isMusicPlaying ? Color.primaryYellow : Color.gray.opacity(0.5))
                    .clipShape(Circle())
            }
            .onAppear {
                if isMusicPlaying {
                    MusicManager.shared.playMusic()
                }
            }
        }
    }
}

#Preview {
    MusicToggle()
}
