import SwiftUI

struct UpgradeBtn: View {
    
    
    
    var iconName: String
    var upgradeTitle: String
    var upgradeDescription: String
    var action: () -> Void // closure to define the action
    var showBadge: Bool // Control the visibility of the badge
    var onAppear: (() -> Void?)? = nil
    var isDiabled: Bool = false
    
    
    var body: some View {
        Button(action: { action() }) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(upgradeTitle)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(upgradeDescription)
                        .font(.subheadline)
                }
                Spacer()
                
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)  // Size of the icon
                    .padding(8)  // Padding inside the button
                    .background(Circle().stroke(Color(.blue)))
                    .foregroundColor(.blue)
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, alignment: .leading)  // This makes the button fill the horizontal space
        .background(isDiabled ? Color.gray.opacity(0.2) : Color.blue.opacity(0.2) )
        .cornerRadius(24)
        
        //disabled state
        .disabled(isDiabled)
        
        //optional onAppear functions
        .onAppear{
            onAppear?()
        }
    }
}

#Preview {
    UpgradeBtn( iconName: "bolt.fill", upgradeTitle: "Example Title", upgradeDescription: "A short description of the upgrade", action: {print("Button Tapped")}, showBadge: true)
}
