import SwiftUI

// MARK: - Enums styles and configs
enum UpgradeTileStyle {
    case wide
    case slim
    
    var dimensions: (width: CGFloat , height: CGFloat){
        switch self {
        case .wide:
            return (width: 366, height : 306)
        case .slim:
            return (width: 177, height: 306)
        }
    }
}

struct UpgradeTileConfiguration {
    struct Colors {
        let background: Color
        let border: Color
        let description: Color
        
        
        static let enabled = Colors(
            background: .white,
            border: .black,
            description: .black
        )
        
        static let disabled = Colors(
            background: .white,
            border: .gray,
            description: .gray
        )
    }
    
    struct layout {
        let cornerRadius: CGFloat = 24
        let spacing: CGFloat = 10
        let borderWidth: CGFloat = 2
        let contentPadding: CGFloat = 14
    }
    
}
    
    
//MARK: - Content model
//TODO Change or expand current value to number of previously purchased
struct UpgradeTileContent{
    let image: String
    let description: String
    let cost: Int
    let currentValue: String
    
}


//MARK: - Main view
//TODO
struct UpgradeTile: View {
    // MARK: - Environment
    @EnvironmentObject var gameState: GameState
    
    @State private var isEnabled: Bool = true
    
    // MARK: - Properties
    private let content : UpgradeTileContent
    private let style: UpgradeTileStyle
    private let canAfford: Bool
    private let action: () -> Void
    
    private let layout = UpgradeTileConfiguration.layout()
    
    
    init(
        content: UpgradeTileContent,
        style: UpgradeTileStyle = .wide,
        canAfford: Bool,
        action: @escaping () -> Void
    ) {
        self.content = content
        self.style = style
        self.canAfford = canAfford
        self.action = action
    }
    
    private var colors: UpgradeTileConfiguration.Colors {
        canAfford ? .enabled : .disabled
    }
    
    // Style configuration structure
    struct tileStyleConfiguration {
        let backgroundColor: Color
        let borderColor: Color
        let borderWidth: CGFloat
        let titleTextColor: Color
        let descriptionTextColor: Color
    }
    
    
    
    // MARK: - body
    var body: some View {
        VStack(alignment: .leading, spacing: layout.spacing) {
            if style == .wide {
                wideLayoutContent
            } else {
                slimLayoutContent
            }
        }
        .frame(
            width: style.dimensions.width,
            height: style.dimensions.height
        )
        .background(colors.background)
        .cornerRadius(layout.cornerRadius)
        .shadow(color: .black, radius: 0, x: 0, y:4)
        .overlay(
            RoundedRectangle(cornerRadius: layout.cornerRadius)
                .strokeBorder(colors.border, lineWidth: layout.borderWidth)
        )
    }
}


//MARK: - layout views
extension UpgradeTile {
    //wide layout
    private var wideLayoutContent: some View {
        VStack {
            ZStack {
                upgradeImage
     
                upgradeInfo
            }
            .overlay(RoundedRectangle(cornerRadius: layout.cornerRadius)
                .strokeBorder(colors.border, lineWidth: layout.borderWidth)
            )
            purchaseButton
                .padding(layout.contentPadding)
        }
    }
    
    private var slimLayoutContent: some View{
        VStack (spacing: layout.spacing) {
            ZStack{
                upgradeImage

                upgradeInfo
            }.overlay(RoundedRectangle(cornerRadius: layout.cornerRadius)
                .strokeBorder(colors.border, lineWidth: layout.borderWidth)
            )
            
            purchaseButton
                .padding(layout.contentPadding)
        }
    }
}
        

//MARK: - Subviews
extension UpgradeTile {
    private var upgradeImage: some View {
        Image(content.image)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 216)
    }
    
    private var upgradeInfo: some View {
        VStack (alignment: .center){
            Spacer()
            Image("icon-question-filled")
                .resizable()
                .frame(width: 16, height: 16)
            
            Text(content.description)
                .font(.custom("JetBrainsMono-Bold", size: 16))
                .foregroundColor(colors.description)
                .multilineTextAlignment(.center)
                .padding(.bottom, layout.contentPadding)
                .padding(.horizontal, style == .wide ? 64 : 16)
        }
        
    }
    
    private var purchaseButton: some View {
        CustomGameButton(
            title: "\(content.cost)",
            suffixImage: "honeyIcon",
            action: action,
            isEnabled: canAfford
            )
    }
    
}


// MARK: - Preview Provider
struct UpgradeTile_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Wide Layout
            UpgradeTile(
                content: UpgradeTileContent(
                    image: "placeholderIMGH",
                    description: "Increases number of bees that spawn",
                    cost: 500,
                    currentValue: "Current Hives: 1"
                ),
                style: .wide,
                canAfford: true,
                action: { print("Purchase action") }
            )
            .previewDisplayName("Wide Layout")
            
            // Slim Layout
            UpgradeTile(
                content: UpgradeTileContent(
                    image: "placeholderIMGV",
                    description: "Makes bees move faster",
                    cost: 1000,
                    currentValue: "Current Speed: 1.0x"
                ),
                style: .slim,
                canAfford: true,
                action: { print("Purchase action") }
            )
            .previewDisplayName("Slim Layout")
        }
        .padding()
        .environmentObject(GameState())
        .previewLayout(.sizeThatFits)
    }
}
