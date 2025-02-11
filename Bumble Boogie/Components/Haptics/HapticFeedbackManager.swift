import CoreHaptics

class HapticFeedbackManager {
    // Internally, you might have a shared CHHapticEngine.
    static let shared = HapticFeedbackManager()  // Shared singleton
    private var engine: CHHapticEngine?
    
    init?() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Failed to initialize haptic engine: \(error)")
            return nil
        }
    }
    
    /// Play a custom rich haptic ensemble by composing multiple events.
    func testCustomFeedback() {
        // Build an array of haptic events (with different intensities, durations, etc.)
        let event1 = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
            ],
            relativeTime: 0.0
        )
        
        let event2 = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            ],
            relativeTime: 0.1,
            duration: 0.2
        )
        
        do {
            let pattern = try CHHapticPattern(events: [event1, event2], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play rich haptic ensemble: \(error)")
        }
    }
    
    // Other custom haptic feedback functions...
}
