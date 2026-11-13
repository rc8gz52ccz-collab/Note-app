import SwiftUI

// Frosted Glass Neon Panel Component
struct NeonPanel<Content: View>: View {
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var neonPink: Color
    var neonBlue: Color
    var hasFill: Bool = true
    @ViewBuilder var customBackground: () -> Content
    
    init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        neonPink: Color,
        neonBlue: Color,
        hasFill: Bool = true,
        @ViewBuilder customBackground: @escaping () -> Content = { Color.clear }
    ) {
        self.width = width
        self.height = height
        self.neonPink = neonPink
        self.neonBlue = neonBlue
        self.hasFill = hasFill
        self.customBackground = customBackground
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if hasFill {
                customBackground()
            } else {
                Color.clear
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [neonPink, neonBlue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.0
                )
        )
    }
}

extension Color {
    static let neonBlue = Color(red: 0.2, green: 0.7, blue: 1.0)
    
    static let neonPink = Color(red: 0.8, green: 0.3, blue: 0.7)
    
    static let dark = Color(red: 0.09, green: 0.09, blue: 0.12)
    
    static let lilac = Color(red: 0.45, green: 0.5, blue: 0.95)
    
    static let iceBlue = Color(red: 0.63, green: 0.91, blue: 0.98)
    
    static let lavender = Color(red: 0.54, green: 0.74, blue: 0.99)
    
    static let berry = Color(red: 0.60, green: 0.14, blue: 0.47)
    
    static let brightOrange = Color(red: 0.91, green: 0.52, blue: 0.23)
}

extension UIColor {
    static let lilac = UIColor(red: 0.45, green: 0.5, blue: 0.95, alpha: 1)
    
    static let iceBlue = UIColor(red: 0.63, green: 0.91, blue: 0.98, alpha: 1)
    
    static let lavender = UIColor(red: 0.54, green: 0.74, blue: 0.99, alpha: 1)
    
    static let berry = UIColor(red: 0.60, green: 0.14, blue: 0.47, alpha: 1)
    
    static let brightOrange = UIColor(red: 0.91, green: 0.52, blue: 0.23, alpha: 1)
}
