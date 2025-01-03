//import SwiftUI
//
//struct UpgradeBtn: View {
//    
//    
//    
//    var iconName: String
//    var upgradeTitle: String
//    var upgradeDescription: String
//    var action: () -> Void // closure to define the action
//    var showBadge: Bool // Control the visibility of the badge
//    var onAppear: (() -> Void?)? = nil
//    var isDisabled: Bool = false
//    
//    
//    var body: some View {
//        Button(action: { action() }) {
//            HStack {
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(upgradeTitle)
//                        .font(.title3)
//                        .fontWeight(.heavy)
//                        .foregroundColor(!isDisabled ? Color("fg-primary") : .gray)
//                    Text(upgradeDescription)
//                        .font(.subheadline)
//                        .foregroundColor(!isDisabled ? Color("fg-primary") : .gray)
//                }
//                Spacer()
//                
//                Image(systemName: iconName)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 24, height: 24)  // Size of the icon
//                    .padding(8)  // Padding inside the button
//                    .background(Circle().stroke(Color((!isDisabled ? .black : .gray))))
//                    .foregroundColor((!isDisabled ? .primaryYellow : .gray))
//            }
//          
//            
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)  // This makes the button fill the horizontal space
//        
////        .background(Color.white)
//        .padding(24)
//        .background(.white)
//        .cornerRadius(10)
//        .overlay(
//        RoundedRectangle(cornerRadius: 10)
//        .inset(by: 1)
//        .stroke(!isDisabled ? Color("primaryForeground") : Color.white.opacity(0.5), lineWidth: 2)
//        )
//        
//        //disabled state
//        .disabled(isDisabled)
//        
//        //optional onAppear functions
//        .onAppear{
//            onAppear?()
//        }
//    }
//}
//
//#Preview {
//    UpgradeBtn( iconName: "bolt.fill", upgradeTitle: "Example Title", upgradeDescription: "A short description of the upgrade", action: {print("Button Tapped")}, showBadge: true)
//}
