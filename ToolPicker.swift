import SwiftUI
import PencilKit

class viewModel: ObservableObject {
    @Published var isRulerActive: Bool = false
}

enum DrawingTool {
    case fountainPen
    case marker
    case pen
    case monoline
    case eraser
    case lasso
}

enum EraserType {
    case vector // Erases whole strokes
    case bitmap // Erases pixels/segments by width
}

struct DrawingView: View {
    @State private var drawing = PKDrawing()
    @State private var selectedTool: DrawingTool = .fountainPen
    @State private var selectedColor: [DrawingTool: UIColor] = [
        .fountainPen: .lavender,
        .pen: .iceBlue,
        .monoline: .berry,
        .marker: .brightOrange
    ]
    
    let neonBlue = Color(red: 0.2, green: 0.7, blue: 1.0)
    let neonPink = Color(red: 0.8, green: 0.3, blue: 0.7)
    
    // A smart binding that automatically gets/sets the color for the currently active tool
    var activeColorBinding: Binding<UIColor> {
        Binding(
            get: { selectedColor[selectedTool] ?? .lavender },
            set: { newColor in selectedColor[selectedTool] = newColor }
        )
    }

    // --- All tool width & state variables declared here in scope ---
    @State private var fountainPenWidth: CGFloat = 5.0
    @State private var penWidth: CGFloat = 3.0
    @State private var monolineWidth: CGFloat = 4.0
    @State private var markerWidth: CGFloat = 15.0
    @State private var eraserWidth: CGFloat = 20.0
    @State private var markerOpacity: Double = 0.8
    @State private var eraserType: EraserType = .vector
    
    var body: some View {
        ZStack {
            PKCanvasContainer(
                drawing: $drawing,
                selectedTool: $selectedTool,
                selectedColor: $selectedColor,
                penWidth: penWidth,
                fountainPenWidth: fountainPenWidth,
                monolineWidth: monolineWidth,
                markerWidth: markerWidth,
                eraserWidth: eraserWidth,
                markerOpacity: markerOpacity,
                eraserType: eraserType
            )
            
            ToolPickerFloat(
                selectedTool: $selectedTool,
                selectedColor: $selectedColor,
                penWidth: $penWidth,
                fountainPenWidth: $fountainPenWidth,
                monolineWidth: $monolineWidth,
                markerWidth: $markerWidth,
                eraserWidth: $eraserWidth,
                markerOpacity: $markerOpacity,
                eraserType: $eraserType
            )
        }
    }
}

struct PKCanvasContainer: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var selectedTool: DrawingTool
    @Binding var selectedColor: [DrawingTool: UIColor]
    
    // --- Added these properties so PKCanvasContainer has them in scope ---
    var penWidth: CGFloat
    var fountainPenWidth: CGFloat
    var monolineWidth: CGFloat
    var markerWidth: CGFloat
    var eraserWidth: CGFloat
    var markerOpacity: Double
    var eraserType: EraserType
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawing = drawing
        canvasView.delegate = context.coordinator
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        canvasView.drawingPolicy = .pencilOnly
        canvasView.overrideUserInterfaceStyle = .light
        
        updateCanvasTool(canvasView)
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing != drawing {
            uiView.drawing = drawing
        }
        updateCanvasTool(uiView)
    }
    
    private func updateCanvasTool(_ canvasView: PKCanvasView) {
        let currentColor = selectedColor[selectedTool] ?? .lavender
        let alpha: CGFloat = (selectedTool == .marker) ? markerOpacity : 0.6
        let activeUIColor = currentColor.withAlphaComponent(alpha)
        
        switch selectedTool {
        case .pen:
            canvasView.tool = PKInkingTool(.pen, color: currentColor, width: penWidth)
        case .fountainPen:
            canvasView.tool = PKInkingTool(.fountainPen, color: currentColor, width: fountainPenWidth)
        case .monoline:
            canvasView.tool = PKInkingTool(.monoline, color: currentColor, width: monolineWidth)
        case .marker:
            canvasView.tool = PKInkingTool(.marker, color: activeUIColor, width: markerWidth)
        case .eraser:
            if eraserType == .bitmap {
                canvasView.tool = PKEraserTool(.bitmap, width: eraserWidth)
            } else {
                canvasView.tool = PKEraserTool(.vector)
            }
        case .lasso:
            canvasView.tool = PKLassoTool()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PKCanvasContainer
        
        init(_ parent: PKCanvasContainer) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
        }
    }
}

// MARK: - Custom Tool Picker Row with iOS-Style Popovers

struct ToolPickerFloat: View {
    @Binding var selectedTool: DrawingTool
    @Binding var selectedColor: [DrawingTool: UIColor]
    @Environment(\.undoManager) var undoManager
    
    // Tool Thickness Bindings
    @Binding var penWidth: CGFloat
    @Binding var fountainPenWidth: CGFloat
    @Binding var monolineWidth: CGFloat
    @Binding var markerWidth: CGFloat
    @Binding var eraserWidth: CGFloat
    
    // Special Tool Property Bindings
    @Binding var markerOpacity: Double
    @Binding var eraserType: EraserType
    
    // Popover Presentation State
    @State private var activePopoverTool: DrawingTool? = nil
    
    var currentColor: UIColor {
        selectedColor[selectedTool] ?? .iceBlue
    }
    
    let neonBlue = Color(red: 0.2, green: 0.7, blue: 1.0)
    let neonPink = Color(red: 0.8, green: 0.3, blue: 0.7)
    let lilac = Color(red: 0.45, green: 0.5, blue: 0.95)
    
    // Helper to handle double-tap / tap logic
    private func handleToolTap(_ tool: DrawingTool) {
        if selectedTool == tool {
            if tool != .lasso {
                activePopoverTool = tool
            }
        } else {
            selectedTool = tool
        }
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 17) {
            HStack(spacing: 10) {
                Button(action: { undoManager?.undo() }) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [neonBlue, neonPink],
                                startPoint: .trailing,
                                endPoint: .top
                            )
                        )
                        .offset(y: -0.4)
                }
                .buttonStyle(.plain)
                .frame(width: 20, height: 20)
                .background(Color.white.opacity(0.08))
                .clipShape(Circle())
                
                Button(action: { undoManager?.redo() }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundStyle(
                            LinearGradient(
                                colors: [neonBlue, neonPink],
                                startPoint: .leading,
                                endPoint: .top
                            )
                        )
                        .offset(y: -0.4)
                }
                .buttonStyle(.plain)
                .frame(width: 20, height: 20)
                .background(Color.white.opacity(0.08))
                .clipShape(Circle())
            }
            .font(.system(size: 11, weight: .regular))
            .offset(y: -21)
            
            Button {
                handleToolTap(.pen)
            } label: {
                CustomPenView(isSelected: selectedTool == .pen, selectedColor: $selectedColor, neonPink: neonPink)
            }
            .buttonStyle(.plain)
            .popover(isPresented: Binding(
                get: { activePopoverTool == .pen },
                set: { if !$0 { activePopoverTool = nil } }
            ), arrowEdge: .top) {
                ToolOptionsPopover(
                    width: $penWidth,
                    widthRange: 1...20,
                    neonPink: neonPink,
                    neonBlue: neonBlue
                )
            }
            // 2. Calligraphy / Fountain Pen
            Button {
                handleToolTap(.fountainPen)
            } label: {
                CustomFountainPenView(isSelected: selectedTool == .fountainPen, selectedColor: $selectedColor, neonPink: neonPink)
            }
            .buttonStyle(.plain)
            .popover(isPresented: Binding(
                get: { activePopoverTool == .fountainPen },
                set: { if !$0 { activePopoverTool = nil } }
            ), arrowEdge: .top) {
                ToolOptionsPopover(
                    width: $fountainPenWidth,
                    widthRange: 1...30,
                    neonPink: neonPink,
                    neonBlue: neonBlue
                )
            }
            
            // 3. Monoline
            Button {
                handleToolTap(.monoline)
            } label: {
                CustomMonolineView(isSelected: selectedTool == .monoline, selectedColor: $selectedColor, neonPink: neonPink)
            }
            .buttonStyle(.plain)
            .popover(isPresented: Binding(
                get: { activePopoverTool == .monoline },
                set: { if !$0 { activePopoverTool = nil } }
            ), arrowEdge: .top) {
                ToolOptionsPopover(
                    width: $monolineWidth,
                    widthRange: 1...40,
                    neonPink: neonPink,
                    neonBlue: neonBlue
                )
            }
            
            // 4. Marker (Width + Opacity)
            Button {
                handleToolTap(.marker)
            } label: {
                CustomMarkerView(isSelected: selectedTool == .marker, selectedColor: $selectedColor, neonPink: neonPink)
            }
            .buttonStyle(.plain)
            .popover(isPresented: Binding(
                get: { activePopoverTool == .marker },
                set: { if !$0 { activePopoverTool = nil } }
            ), arrowEdge: .top) {
                ToolOptionsPopover(
                    width: $markerWidth,
                    widthRange: 5...60,
                    opacity: $markerOpacity,
                    neonPink: neonPink,
                    neonBlue: neonBlue
                )
            }
            
            // 5. Eraser (Width + Pixel vs Vector Toggle)
            Button {
                handleToolTap(.eraser)
            } label: {
                CustomEraserView(isSelected: selectedTool == .eraser, neonPink: neonPink)
            }
            .buttonStyle(.plain)
            .popover(isPresented: Binding(
                get: { activePopoverTool == .eraser },
                set: { if !$0 { activePopoverTool = nil } }
            ), arrowEdge: .top) {
                EraserOptionsPopover(
                    width: $eraserWidth,
                    eraserType: $eraserType,
                    neonPink: neonPink,
                    neonBlue: neonBlue
                )
            }
            
            // 6. Lasso
            Button {
                handleToolTap(.lasso)
            } label: {
                CustomLassoView(isSelected: selectedTool == .lasso, neonPink: neonPink)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 1)
            
            ZStack(alignment: .center) {
                Circle()
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                .red, .pink, .purple, .indigo, .blue, .cyan, .mint, .green, Color(red: 0.6, green: 0.9, blue: 0), .yellow, .orange, .red
                            ]),
                            center: .center
                        )
                    )
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.white.opacity(1), Color.white.opacity(0)]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 9
                                )
                            )
                    )
                    .allowsHitTesting(false)
                
                ColorPicker("", selection: Binding(
                    get: { Color(uiColor: currentColor) },
                    set: { selectedColor[selectedTool] = UIColor($0) }
                ), supportsOpacity: true)
                .labelsHidden()
                .opacity(0.001)
                .contentShape(Circle())
                .frame(width: 20, height: 20)
                .allowsHitTesting(true)
            }
            .frame(width: 20, height: 20)
            .offset(y: -21)
            .padding(.trailing, 1)
        }
        .offset(y: -1)
        .frame(width: 322, height: 68)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.05), Color.white.opacity(0.005)],
                startPoint: .bottom, endPoint: .top))
        .clipShape(Capsule())
    }
}

struct BoundedArea<Content: View>: View {
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            let parentW = geometry.size.width
            let parentH = geometry.size.height
            
            let objectW: CGFloat = 322
            let objectH: CGFloat = 68
            
            let minX: CGFloat = 0 + parentW/100
            let maxX: CGFloat = parentW - objectW
            let minY: CGFloat = objectW/2 + parentH/100
            let maxY: CGFloat = parentH - objectH
            
            content
                .frame(width: 322, height: 68)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { value in
                            let finalX = lastOffset.width + value.translation.width
                            let finalY = lastOffset.height + value.translation.height
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                offset = CGSize(
                                    width: min(max(finalX, minX), maxX),
                                    height: min(max(finalY, minY), maxY)
                                )
                                lastOffset = offset // Save the valid resting position
                            }
                        }
                )
        }
    }
}

// MARK: - Simplified Tool Options Popover
struct ToolOptionsPopover: View {
    @Binding var width: CGFloat
    var widthRange: ClosedRange<CGFloat>
    var opacity: Binding<Double>? = nil
    
    let neonPink: Color
    let neonBlue: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Width Slider
            VStack(alignment: .leading, spacing: 4) {
                Text("Width: \(Int(width)) pt")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
                
                Slider(value: $width, in: widthRange, step: 1)
                    .accentColor(neonBlue)
            }
            
            // Optional Opacity Slider (used by Marker)
            if let opacityBinding = opacity {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Opacity: \(Int(opacityBinding.wrappedValue * 100))%")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Slider(value: opacityBinding, in: 0.1...1.0, step: 0.05)
                        .accentColor(neonPink)
                }
            }
        }
        .padding(14)
        .frame(width: 200)
        .background(Color.white.opacity(0.06))
        .cornerRadius(16)
    }
}

// MARK: - Simplified Eraser Options Popover

struct EraserOptionsPopover: View {
    @Binding var width: CGFloat
    @Binding var eraserType: EraserType
    
    let neonPink: Color
    let neonBlue: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Eraser Type Picker (Vector vs Bitmap)
            Picker("Eraser Type", selection: $eraserType) {
                Text("Vector").tag(EraserType.vector)
                Text("Bitmap").tag(EraserType.bitmap)
            }
            .pickerStyle(.segmented)
            
            // Width Slider (Only shown for bitmap eraser)
            if eraserType == .bitmap {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Size: \(Int(width)) pt")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Slider(value: $width, in: 5...50, step: 1)
                        .accentColor(neonBlue)
                }
            }
        }
        .padding(14)
        .frame(width: 200)
        .background(Color(white: 0.12).opacity(0.95))
        .cornerRadius(16)
    }
}

// MARK: - Native iOS Color Picker Wrapper
struct NativeColorPickerRepresentable: UIViewControllerRepresentable {
    @Binding var selectedColor: Color
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let picker = UIColorPickerViewController()
        picker.selectedColor = UIColor(selectedColor)
        picker.delegate = context.coordinator
        picker.supportsAlpha = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIColorPickerViewController, context: Context) {
        uiViewController.selectedColor = UIColor(selectedColor)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        var parent: NativeColorPickerRepresentable
        
        init(_ parent: NativeColorPickerRepresentable) {
            self.parent = parent
        }
        
        func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            parent.selectedColor = Color(viewController.selectedColor)
        }
        
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
