import SwiftUI
import WebKit

// Model representing a text/LaTeX block placed on a document page
struct LaTeXAnnotation: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var latexString: String
    var position: CGPoint
    
    // Automatically defaults to a safe spot on the page if none is given
    init(id: UUID = UUID(), latexString: String, position: CGPoint) {
        self.id = id
        self.latexString = latexString
        self.position = position
    }
}

// SwiftUI Popover for entering LaTeX code
struct LaTeXInputPopover: View {
    @Binding var isPresented: Bool
    @State private var latexInput: String = ""
    var onCommit: (String) -> Void
    var onDelete: () -> Void
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [Color.neonBlue.opacity(0.05), Color.neonBlue.opacity(0.01), Color.clear]),
                center: .bottomLeading,
                startRadius: 10,
                endRadius: 380
            )
            .background(Color.dark)
            
            VStack(spacing: 0) {
                TextEditor(text: $latexInput)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(Color.lavender)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                
                HStack {
                    Button(action: {
                        onDelete()
                    }) {
                        Image(systemName: "xmark.square.fill")
                    }
                    Spacer()
                    
                    Button(action: {
                        if !latexInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onCommit(latexInput)
                        }
                        isPresented = false
                    }) {
                        Image(systemName: "checkmark.square.fill") 
                    }
                }
                .font(.system(size: 28, weight: .light))
                .padding(8)
            }
            .frame(alignment: .bottom)
            .foregroundStyle(Color.lilac.opacity(0.8))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [Color.neonBlue, Color.neonPink],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    ),
                    lineWidth: 1
                )
        )
        .frame(maxHeight: 300)
        .padding(10)
    }
}

struct MathJaxView: UIViewRepresentable {
    let latex: String
    var fontSize: CGFloat = 8
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js"></script>
          <style>
            body {
              background-color: transparent;
              color: white;
              margin: 0;
              padding: 4px;
              display: flex;
              align-items: center;
              justify-content: center;
            }
            .mjx-chtml { color: white !important; }
            svg { fill: white !important; }
          </style>
        </head>
        <body>
          \\[ \(latex) \\]
        </body>
        </html>
        """
        uiView.loadHTMLString(html, baseURL: nil)
    }
}
