import SwiftUI
import PencilKit
import WebKit

struct PageView: View {
    @Binding var activeTab: Int
    @Binding var page: Page
    @Binding var document: Document
    @Environment(\.undoManager) var undoManager
    
    @State private var selectedPageID: Page.ID?
    @State private var selectedAnnotationID: UUID? = nil
    @State private var isLaTeXInputPresented = false
    @State private var latexAnnotations: [LaTeXAnnotation] = []
    let A4Width: CGFloat = 595.27
    let A4Height: CGFloat = 841.89
    let margin: CGFloat = 40
    
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
        ZStack(alignment: .topLeading) {
            // Full-Screen Deep Space Background
            Color(red: 0.08, green: 0.08, blue: 0.1)
                .ignoresSafeArea()
                .onTapGesture {
                    selectedPageID = page.id
                }
            
            ZStack {
                ForEach($page.latexAnnotations) { $annotation in 
                    let isSelected = (selectedAnnotationID == annotation.id)
                    
                    MathJaxView(latex: annotation.latexString)
                        .fixedSize()
                        .padding(4)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isSelected ? Color.neonBlue : Color.clear, lineWidth: 0.6)
                        )
                        .onTapGesture {
                            selectedAnnotationID = annotation.id
                        }
                        .contextMenu {
                            menuContent(for: annotation)
                        }
                }  
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func menuContent(for annotation: LaTeXAnnotation) -> some View {
        HStack(spacing: 12) {
            Button(action: {
                UIPasteboard.general.string = annotation.latexString
                page.latexAnnotations.removeAll { $0.id == annotation.id }
            }) {
                Image(systemName: "scissors")
                    .font(.system(size: 8, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [neonPink, neonBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Button(action: { 
                page.latexAnnotations.removeAll { $0.id == annotation.id }
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 8, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [neonPink, neonBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.04))
        .clipShape(Capsule())
    }
}
