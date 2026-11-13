import SwiftUI
import PencilKit

struct CustomFountainPenView: View {
    var isSelected: Bool
    @Binding var selectedColor: [DrawingTool: UIColor]
    var neonPink: Color
    
    var body: some View {
        let currentColor = selectedColor[.fountainPen] ?? .lavender
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            ZStack(alignment: .bottom) {
                FountainpenRod(isSelected: isSelected, activeColor: Color(uiColor: currentColor))
                FountainTip(isSelected: isSelected)
            }
        }
        .frame(width: 14, height: 69, alignment: .bottom)
    }
}

struct CustomPenView: View {
    var isSelected: Bool
    @Binding var selectedColor: [DrawingTool: UIColor]
    var neonPink: Color
    
    var body: some View {
        let currentColor = selectedColor[.pen] ?? .iceBlue
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            ZStack(alignment: .bottom) {
                BaseRod(isSelected: isSelected)
                PenTip(isSelected: isSelected, activeColor: Color(uiColor: currentColor))
            }
        }
        .frame(width: 14, height: 69, alignment: .bottom)
    }
}

struct CustomMonolineView: View {
    var isSelected: Bool
    @Binding var selectedColor: [DrawingTool: UIColor]
    var neonPink: Color
    
    var body: some View {
        let currentColor = selectedColor[.monoline] ?? .berry
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            ZStack(alignment: .bottom) {
                BaseRod(isSelected: isSelected)
                MonolineTip(isSelected: isSelected, activeColor: Color(uiColor: currentColor))
            }
        }
        .frame(width: 14, height: 69, alignment: .bottom)
    }
}

struct CustomMarkerView: View {
    var isSelected: Bool
    @Binding var selectedColor: [DrawingTool: UIColor]
    var neonPink: Color
    
    var body: some View {
        let currentColor = selectedColor[.marker] ?? .brightOrange
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            ZStack(alignment: .bottom) {
                MarkerTip(isSelected: isSelected, activeColor: Color(uiColor: currentColor))
                BaseRod(isSelected: isSelected)
                colorline(isSelected: isSelected, activeColor: Color(uiColor: currentColor))
            }
        }
        .frame(width: 14, height: 69, alignment: .bottom)
    }
}

struct CustomEraserView: View {
    var isSelected: Bool
    var neonPink: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            ZStack(alignment: .bottom) {
                BaseRod(isSelected: isSelected)
                EraserTool(isSelected: isSelected)
            }
        }
        .frame(width: 14, height: 69, alignment: .bottom)
    }
}

struct CustomLassoView: View {
    var isSelected: Bool
    var neonPink: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            ZStack(alignment: .bottom) {
                BaseRod(isSelected: isSelected)
                LassoTip(isSelected: isSelected)
            }
        }
        .frame(width: 14, height: 69, alignment: .bottom)
    }
}

// MARK: - Reusable Base Rod Component
struct BaseRod: View {
    var isSelected: Bool
    
    let width: CGFloat = 10.5
    let standardHeight: CGFloat = 24.0
    let raisedExtraHeight: CGFloat = 14
    
    var body: some View {
        bodyGradient
            .frame(width: width, height: standardHeight + (isSelected ? raisedExtraHeight : 0))
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 2.8,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 2.8
                )
            )
            .frame(maxWidth: .infinity, alignment: .center)
            .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

struct FountainpenRod: View {
    var isSelected: Bool
    var activeColor: Color
    
    let width: CGFloat = 10.5
    let standardHeight: CGFloat = 24.0
    let raisedExtraHeight: CGFloat = 14
    
    var body: some View {
        ZStack(alignment: .top) {
            // 1. The main base rod
            bodyGradient
                .frame(width: width, height: standardHeight + (isSelected ? raisedExtraHeight : 0))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 2.8,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 2.8
                    )
                )
            
            // 2. The little snip cap sitting right at the top of the rod
            ZStack {
                bodyGradient
                    .frame(width: 10.5, height: 1.6)
                    .scaleEffect(x: 8.4 / 10.5, y: 1, anchor: .center)
                    .frame(width: 8.4, height: 1.6)
                    .cornerRadius(2.5)
            }
            .offset(y: -1.35) // Centers the 1.6 height cap right on the top edge
            
            // 3. Active color line spanning straight across the main rod underneath/near the top
            activeColor
                .frame(width: width, height: 2.0)
                .cornerRadius(0.3)
                .offset(y: 5.8)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

struct FountainTip: View {
    var isSelected: Bool = false
    
    let width: CGFloat = 10.5
    let height: CGFloat = 16.0
    let standardHeight: CGFloat = 24.0
    let raisedExtraHeight: CGFloat = 14

    var body: some View {
        let currentRodHeight = standardHeight + (isSelected ? raisedExtraHeight : 0)
        
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: -2.98, y: 15.74))
                    
                    path.addCurve(
                        to: CGPoint(x: -4.1, y: 9.34),
                        control1: CGPoint(x: -2.98, y: 13.0),
                        control2: CGPoint(x: -4.8, y: 11.5)
                    )
                    
                    path.addCurve(
                        to: CGPoint(x: 0, y: 0),
                        control1: CGPoint(x: -2.2, y: 5.5),
                        control2: CGPoint(x: -0.1, y: 1.2)
                    )
                    
                    path.addCurve(
                        to: CGPoint(x: 4.1, y: 9.34),
                        control1: CGPoint(x: 0.1, y: 1.2),
                        control2: CGPoint(x: 2.2, y: 5.5)
                    )
                    
                    path.addCurve(
                        to: CGPoint(x: 2.98, y: 15.74),
                        control1: CGPoint(x: 4.8, y: 11.5),
                        control2: CGPoint(x: 2.98, y: 13.0)
                    )
                    
                    path.closeSubpath()
                }
                .fill(FountainGradient)
                .offset(x: width / 2)
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 1.5))
                    path.addLine(to: CGPoint(x: 0, y: 10))
                }
                .stroke(Color.black, lineWidth: 0.11)
                .offset(x: width / 2)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 1.4, height: 1.4)
                    .position(x: width / 2, y: 10)
                }
        }
        .offset(y: -currentRodHeight)
        .frame(width: width, height: 17)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

// MARK: Pen Tip
struct PenTip: View {
    var isSelected: Bool = false
    var activeColor: Color
    
    let width: CGFloat = 10.5
    let height: CGFloat = 19.9
    let standardHeight: CGFloat = 21.85
    let raisedExtraHeight: CGFloat = 14

    var body: some View {
        let currentRodHeight = standardHeight + (isSelected ? raisedExtraHeight : 0)
        
        Canvas { context, size in
            let w = size.width
            let h = size.height
            
            // 1. Define the exact cone boundary path
            var conePath = Path()
            conePath.move(to: CGPoint(x: w / 2, y: 0))
            conePath.addLine(to: CGPoint(x: w, y: h))
            conePath.addLine(to: CGPoint(x: 0, y: h))
            conePath.closeSubpath()
            
            // 2. Draw the scaling row-by-row gradient across the ENTIRE cone first
            let step: CGFloat = 0.5
            var y: CGFloat = 0
            while y <= h {
                let progress = y / h
                let currentWidth = w * progress
                let leftX = (w - currentWidth) / 2
                let rightX = leftX + currentWidth
                
                if currentWidth > 0 {
                    var rowPath = Path()
                    rowPath.move(to: CGPoint(x: leftX, y: y))
                    rowPath.addLine(to: CGPoint(x: rightX, y: y))
                    
                    context.stroke(
                        rowPath,
                        with: .linearGradient(
                            Gradient(stops: conegradient),
                            startPoint: CGPoint(x: leftX, y: y),
                            endPoint: CGPoint(x: rightX, y: y)
                        ),
                        lineWidth: step + 0.4
                    )
                }
                y += step
            }
        }
        .offset(y: -currentRodHeight)
        .frame(width: width, height: height)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
        
        ZStack{
            Rectangle()
                .fill(activeColor)
                .cornerRadius(0.3)
                .frame(width: width, height: 2.0)
                .offset(y: 13.5) // Sits right at the base of the cone view
            
            // 3. Mini top-cone lead tip in activeColor positioned at the apex
            Path { path in
                path.move(to: CGPoint(x: width/2.43, y: height * 0.2))
                path.addLine(to: CGPoint(x: width/1.69, y: height * 0.2))
                path.addLine(to: CGPoint(x: width / 2, y: 0.1))
                path.closeSubpath()
            }
            .fill(activeColor)
            .cornerRadius(3.0)
        }
        .offset(y: -currentRodHeight)
        .frame(width: width, height: height)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

struct MonolineTip: View {
    var isSelected: Bool = false
    var activeColor: Color
    
    let baseWidth: CGFloat = 10.5
    let standardHeight: CGFloat = 18
    let raisedExtraHeight: CGFloat = 14
    
    var body: some View {
        let currentRodHeight = standardHeight + (isSelected ? raisedExtraHeight : 0)
        
        VStack(alignment: .center, spacing: 0) {
            
            Rectangle()
                .fill(activeColor)
                .frame(width: 1.0, height: 3.0)
            
            Rectangle()
                .frame(width: 1.6, height: 4.9)
                .foregroundStyle(
                    LinearGradient(
                        stops: [
                            .init(color: Color(white: 0.32), location: 0.0),
                            .init(color: Color(white: 0.01), location: 0.3),
                            .init(color: Color(white: 0.2), location: 0.6),
                            .init(color: Color(white: 0.45), location: 0.8)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            bodyGradient
                .frame(width: baseWidth, height: 4.7)
                .scaleEffect(x: 5.9 / baseWidth, y: 1.0, anchor: .center)
                .frame(width: 5.9, height: 4.7)
                .overlay(alignment: .bottom) {
                    Color.black.opacity(0.1)
                        .frame(height: 0.41)
                }
            
            bodyGradient
                .frame(width: baseWidth, height: 9.0)
                .scaleEffect(x: 8.4 / baseWidth, y: 1.0, anchor: .center)
                .frame(width: 8.4, height: 9.0)
                .overlay(alignment: .bottom) {
                    Color.black.opacity(0.12)
                        .frame(height: 0.43)
                }
            
            ZStack(alignment: .top) {
                bodyGradient
                    .frame(width: baseWidth, height: 3.0)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0.3,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 0.3 // or topTrailingRadius
                        )
                    )
                
                // Color accent band
                Rectangle()
                    .fill(activeColor)
                    .frame(width: baseWidth, height: 1.0)
                    .offset(y: 7.5)
            }
        }
        .offset(y: -currentRodHeight)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

struct EraserTool: View {
    var isSelected: Bool = false
    
    let Width: CGFloat = 11.5
    let standardHeight: CGFloat = 19.62
    let raisedExtraHeight: CGFloat = 14
    
    var body: some View {
        let currentRodHeight = standardHeight + (isSelected ? raisedExtraHeight : 0)
        
        VStack(alignment: .center, spacing: 0) {
            Rectangle()
                .fill(Color.lilac)
                .overlay(
                    LinearGradient(
                        stops: [
                            .init(color: Color(white: 0.32, opacity: 0.03), location: 0.0),
                            .init(color: Color(white: 0.1, opacity: 0.3), location: 0.1),
                            .init(color: Color(white: 0.4, opacity: 0.08), location: 0.45),
                            .init(color: Color(white: 0.39, opacity: 0.08), location: 0.85),
                            .init(color: Color(white: 0.48, opacity: 0.08), location: 0.89),
                            .init(color: Color(white: 0.45, opacity: 0.08), location: 0.9),
                            .init(color: Color(white: 0.69, opacity: 0.08), location: 0.95)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 10.5, height: 9.2)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 2.8,
                        bottomLeadingRadius: 0.1,
                        bottomTrailingRadius: 0.1,
                        topTrailingRadius: 2.8 
                    )
                )
            
            bodyGradient
                .frame(width: 11.5, height: 10.0, alignment: .center)
                .cornerRadius(0.8)
        }
        .offset(y: -currentRodHeight)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

struct colorline: View {
    var isSelected: Bool = false
    var activeColor: Color
    
    let width: CGFloat = 10.5
    let height: CGFloat = 11.9
    let standardHeight: CGFloat = 22.4
    let raisedExtraHeight: CGFloat = 14
    
    var body: some View {
        let currentRodHeight = standardHeight + (isSelected ? raisedExtraHeight : 0)
        
        VStack(alignment: .center, spacing: 0) {
            Rectangle()
                .fill(activeColor)
                .cornerRadius(0.3)
                .frame(width: 10.5, height: 4.0)
                .offset(y: 14.5)
        }
        .offset(y: -currentRodHeight)
        .frame(width: width, height: height)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

struct MarkerTip: View {
    var isSelected: Bool = false
    var activeColor: Color
    
    let width: CGFloat = 10.5
    let height: CGFloat = 5.6
    let standardHeight: CGFloat = 26.3
    let raisedExtraHeight: CGFloat = 14
    
    var body: some View {
        let currentRodHeight = standardHeight + (isSelected ? raisedExtraHeight : 0)
        
        VStack(alignment: .center, spacing: 0) {
            Path { path in
                let w: CGFloat = 5.5
                let h: CGFloat = 8.0 
                
                path.move(to: CGPoint(x: 0, y: h))
                
                path.addLine(to: CGPoint(x: 0, y: h * 0.35))
                
                path.addLine(to: CGPoint(x: w, y: 0))
                
                path.addLine(to: CGPoint(x: w, y: h))
                
                path.closeSubpath()
            }
            .fill(activeColor)
            .frame(width: 5.5, height: 9.0)
            .cornerRadius(1.5)
            .offset(y: 7.2)
            .zIndex(1)
            
            bodyGradient
                .frame(width: width, height: 8.0)
                .scaleEffect(x: 6.5 / width, y: 1.0, anchor: .center)
                .frame(width: 6.5, height: 7.7)
                .cornerRadius(0.8)
                .offset(y: 4.8)
                .zIndex(2)
            
            
            ZStack(alignment: .top) {
                Canvas { context, size in
                    let w = size.width
                    let h = size.height
                    
                    let topWidthRatio: CGFloat = 0.54 
                    let startY: CGFloat = 0
                    
                    let step: CGFloat = 0.5
                    var y: CGFloat = startY
                    while y <= h {
                        let progress = (y - startY) / (h - startY)
                        
                        let currentWidth = w * (topWidthRatio + (1.0 - topWidthRatio) * progress)
                        let leftX = (w - currentWidth) / 2
                        let rightX = leftX + currentWidth
                        
                        if currentWidth > 0 {
                            var rowPath = Path()
                            rowPath.move(to: CGPoint(x: leftX, y: y))
                            rowPath.addLine(to: CGPoint(x: rightX, y: y))
                            
                            context.stroke(
                                rowPath,
                                with: .linearGradient(
                                    Gradient(stops: conegradient),
                                    startPoint: CGPoint(x: leftX, y: y),
                                    endPoint: CGPoint(x: rightX, y: y)
                                ),
                                lineWidth: step + 0.4
                            )
                        }
                        y += step
                    }
                }
            }
            .frame(width: width, height: height)
            .cornerRadius(0.2)
            .zIndex(0)
            .offset(y: 3.8)
        }
        .offset(y: -currentRodHeight)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}

// MARK: - Striped Lasso Tip 
struct LassoTip: View {
    var isSelected: Bool = false
    
    let width: CGFloat = 10.5
    let height: CGFloat = 19.9
    let standardHeight: CGFloat = 21.85
    let raisedExtraHeight: CGFloat = 14
    
    var body: some View {
        let currentRodHeight = standardHeight + (isSelected ? raisedExtraHeight : 0)
        
        Canvas { context, size in
            let w = size.width
            let h = size.height
            
            var conePath = Path()
            conePath.move(to: CGPoint(x: w / 2, y: 0))
            conePath.addLine(to: CGPoint(x: w, y: h))
            conePath.addLine(to: CGPoint(x: 0, y: h))
            conePath.closeSubpath()
            
            let step: CGFloat = 0.5
            var y: CGFloat = 0
            while y <= h {
                let progress = y / h
                let currentWidth = w * progress
                let leftX = (w - currentWidth) / 2
                let rightX = leftX + currentWidth
                
                if currentWidth > 0 {
                    var rowPath = Path()
                    rowPath.move(to: CGPoint(x: leftX, y: y))
                    rowPath.addLine(to: CGPoint(x: rightX, y: y))
                    
                    context.stroke(
                        rowPath,
                        with: .linearGradient(
                            Gradient(stops: conegradient),
                            startPoint: CGPoint(x: leftX, y: y),
                            endPoint: CGPoint(x: rightX, y: y)
                        ),
                        lineWidth: step + 0.2
                    )
                }
                y += step
            }
            
            context.drawLayer { subcontext in
                subcontext.clip(to: conePath)
                subcontext.blendMode = .multiply 
                
                var stripePath = Path()
                for i in stride(from: -38.0, through: 50.0, by: 3.0) {
                    stripePath.move(to: CGPoint(x: i, y: h + 5))
                    stripePath.addLine(to: CGPoint(x: i + 15, y: -5))
                }
                
                subcontext.translateBy(x: w / 2, y: h / 2)
                subcontext.rotate(by: .degrees(20))
                subcontext.translateBy(x: -w / 2, y: -h / 2)
                
                subcontext.stroke(
                    stripePath,
                    with: .color(Color.black.opacity(0.30)),
                    lineWidth: 1.4
                )
            }
        }
        .frame(width: width, height: height)
        .offset(y: -currentRodHeight)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
}
