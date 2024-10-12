import AVFoundation

class MusicManager {
    static let shared = MusicManager()
    var audioPlayer: AVAudioPlayer?

    private init() {
        // Load the audio file
        if let url = Bundle.main.url(forResource: "Boogie-Bee", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            } catch {
                print("Error initializing audio player: \(error)")
            }
        }
        
        // Load and apply previous state from UserDefaults
        if UserDefaults.standard.bool(forKey: "isMusicPlaying") {
            playMusic()
        }
    }

    func playMusic() {
        audioPlayer?.play()
        UserDefaults.standard.set(true, forKey: "isMusicPlaying") // Save music state
    }

    func stopMusic() {
        audioPlayer?.stop()
        UserDefaults.standard.set(false, forKey: "isMusicPlaying") // Save music state
    }

    func toggleMusic() {
        if audioPlayer?.isPlaying == true {
            stopMusic()
        } else {
            playMusic()
        }
    }
}
