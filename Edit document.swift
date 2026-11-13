import SwiftUI
import PencilKit

struct editDocView: View {
    @Binding var activeTab: Int
    @Binding var document: Document
    @Environment(\.undoManager) var undoManager
    
    @State private var selectedPageID: Page.ID?
    @State private var selectedAnnotationID: UUID? = nil
    @State private var isLaTeXInputPresented = false
    @State private var latexAnnotations: [LaTeXAnnotation] = []
    
    @State private var isSidebarVisible: Bool = true
    @State private var selectedTool: DrawingTool = .fountainPen
    @State private var selectedColor: [DrawingTool: UIColor] = [
        .pen: .iceBlue,
        .fountainPen: .lavender,
        .monoline: .berry,
        .marker: .brightOrange
    ]
    
    @State private var fountainPenWidth: CGFloat = 5.0
    @State private var penWidth: CGFloat = 3.0
    @State private var monolineWidth: CGFloat = 4.0
    @State private var markerWidth: CGFloat = 15.0
    @State private var eraserWidth: CGFloat = 20.0
    @State private var markerOpacity: Double = 0.8
    @State private var eraserType: EraserType = .vector
    
    let neonBlue = Color(red: 0.2, green: 0.7, blue: 1.0)
    let neonPink = Color(red: 0.8, green: 0.3, blue: 0.7)
    
    var body: some View {
        ZStack(alignment: .top) {
            // Full-Screen Deep Space Background
            Color(red: 0.08, green: 0.08, blue: 0.1).ignoresSafeArea()
            
            GeometryReader { geo in
                RadialGradient(
                    gradient: Gradient(colors: [neonBlue.opacity(0.4), neonBlue.opacity(0.05), Color.clear]),
                    center: .leading,
                    startRadius: 20,
                    endRadius: geo.size.width * 0.55
                )
                .frame(width: geo.size.width * 0.65, height: geo.size.height)
                .offset(x: -geo.size.width * 0.25)
                .allowsHitTesting(false)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 12) {
                ToolPanel
                MainSplitArea
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .padding(12)
        }
    }
    
    // MARK: - Split helper views to fix the compiler type-check timeout
    
    private var ToolPanel: some View {
        NeonPanel(
            height: 84,
            neonPink: neonPink,
            neonBlue: neonBlue,
            hasFill: true
        ) {
            // GENERAL ICONS
            ZStack(alignment: .top) {
                HStack {
                    house(activeTab: $activeTab)
                        .padding(.leading, 15)
                        .offset(y: 11.6)
                    
                    Spacer()
                    
                    dotMenu()
                        .offset(y: 11)
                }
                .frame(maxWidth: .infinity, maxHeight: 84, alignment: .top)
            }
            .ignoresSafeArea()
            
            // Tool Panel
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    // Toggle Thumbnail Sidebar Button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isSidebarVisible.toggle()
                        }
                    }) {
                        ZStack {
                            Image(systemName: "rectangle.fill")
                                .font(.system(size: 29.8, weight: .thin))
                                .foregroundStyle(
                                    LinearGradient(colors: [neonPink, neonBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                            if !isSidebarVisible {
                                Image(systemName: "rectangle.fill")
                                    .font(.system(size: 30, weight: .thin))
                                    .foregroundStyle(
                                        LinearGradient(colors: [Color(red: 0.08, green: 0.08, blue: 0.1), Color(red: 0.08, green: 0.08, blue: 0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                            }
                            
                            Image(systemName: "inset.filled.leftthird.rectangle")
                                .font(.system(size: 29.9, weight: .thin))
                                .foregroundStyle(
                                    isSidebarVisible ?
                                    LinearGradient(colors: [Color(red: 0.08, green: 0.08, blue: 0.1), Color(red: 0.08, green: 0.08, blue: 0.1)], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [neonPink, neonBlue], startPoint: .topLeading, endPoint:     .bottomTrailing)
                                )
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 8)
                    .offset(y: -1.8)
                    
                    // Editable Document Title Search Box
                    TextField("Document Title", text: $document.title)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color.white.opacity(0.03))
                        .clipShape(RoundedRectangle(cornerRadius: 4.4))
                        .frame(maxWidth: .infinity)
                        .padding(.trailing, 12)
                }
                .padding(.horizontal, 28)
                .ignoresSafeArea()
                
                HStack(spacing: 3) {
                    Button(action: {}) {
                        ZStack {
                            Image(systemName: "square.dotted")
                                .font(.system(size: 25, weight: .light))
                            Image(systemName: "arrow.down.to.line")
                                .font(.system(size: 11, weight: .light))
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 7)
                    
                    Button(action: {
                        if selectedPageID == nil {
                            selectedPageID = document.pages.first?.id
                        }
                        isLaTeXInputPresented = true
                    }) {
                        ZStack {
                            Image(systemName: "rectangle.badge.plus") 
                                .font(.system(size: 24, weight: .thin))
                                .offset(y: 2)
                            
                            Image(systemName: "chevron.left.forwardslash.chevron.right") 
                                .font(.system(size: 10, weight: .light))
                        }
                    }
                    .offset(y: -0.4)
                    .padding(.trailing, 5)
                    
                    Button(action: {}) {
                        Image(systemName: "text.badge.plus")
                            .font(.system(size: 22, weight: .thin))
                    }
                    .padding(.trailing, 5)
                    
                    Button(action: {}) {
                        ZStack {
                            Image(systemName: "badge.plus")
                                .rotationEffect(.degrees(135)) 
                                .font(.system(size: 16, weight: .light))
                                .offset(y: 2)
                            
                            Image(systemName: "square.on.circle")
                                .rotationEffect(.degrees(135))
                                .font(.system(size: 20, weight: .light))
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 5)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .rotationEffect(.degrees(90))
                            .font(.system(size: 26, weight: .thin))
                    }
                    .buttonStyle(.plain)
                    .offset(y: 0)
                }
                .frame(alignment: .leading)
                .offset(x: 0.8, y: 0)
                .foregroundStyle(
                    LinearGradient(
                        colors: [neonPink, neonBlue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }
            .frame(maxWidth: .infinity, maxHeight: 84, alignment: .topLeading)
            .offset(y: 12)
            .padding(.horizontal, 12)
        }
    }
    
    private var MainSplitArea: some View {
        // Content Split Area (Sidebar + Canvas)
        HStack(spacing: 12) {
            // Hideable Left Miniature Sidebar (Fixed narrow 84pt width)
            if isSidebarVisible {
                ZStack(alignment: .top) {
                    NeonPanel(
                        width: 84,
                        neonPink: neonPink,
                        neonBlue: neonBlue,
                        hasFill: false
                    ) {
                        sidebarContent
                    }
                }
                .frame(width: 84)
                .transition(.move(edge: .leading).combined(with: .opacity))
            }
            
            // Main Editor Canvas Panel
            NeonPanel(
                neonPink: neonPink,
                neonBlue: neonBlue,
                hasFill: true
            ) {
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            //ForEach($document.pages) { $page in
                            //    PageView(page: $page)
                            //}
                        }
                        LinearGradient(
                            colors: [Color.clear, Color.clear, Color.lilac, Color.clear, Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        ) 
                        .frame(height: 0.6)
                    }
                    .overlay(alignment: .bottom) {
                        if isLaTeXInputPresented {
                            LaTeXInputPopover(
                                isPresented: $isLaTeXInputPresented,
                                onCommit: { text in
                                    let targetID = selectedPageID ?? document.pages.first?.id
                                    if let index = document.pages.firstIndex(where: { $0.id == targetID }) {
                                        document.pages[index].latexAnnotations.append(LaTeXAnnotation(latexString: text, position: .zero))
                                    }
                                    isLaTeXInputPresented = false
                                },
                                onDelete: {
                                    isLaTeXInputPresented = false
                                }
                            )
                        }
                    }
                }
                .frame(alignment: .bottom)
                .overlay(
                    BoundedArea {
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
                )
            }
        }
    }
    
    private var sidebarContent: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(document.pages) { page in
                    let isSelected = (selectedPageID == page.id)
                    let pageIndex = document.pages.firstIndex(where: { $0.id == page.id }) ?? 0
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                                .stroke(isSelected ?
                                        LinearGradient(
                                            colors: [neonPink, neonBlue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing)
                                        : LinearGradient(
                                            colors: [Color.clear, Color.clear],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing),
                                        lineWidth: 0.6)
                            .background(Color.white.opacity(0.04))
                            .frame(width: 60, height: 60 * 1.4142)
                            .overlay(
                                Text("\(pageIndex + 1)")
                                    .font(.system(size: 10, weight: .light))
                                    .foregroundColor(Color.lavender)
                            )
                            .onTapGesture {
                                selectedPageID = page.id
                            }
                    }
                    // New Page Trigger Button
                    Button(action: {
                        document.pages.append(Page())
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [neonPink, neonBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60 * 1.4142)
                            .background(Color.white.opacity(0.04))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 12)
        }
    }   
}


