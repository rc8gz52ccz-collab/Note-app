import SwiftUI

struct DocumentPagesScrollView: View {
    @Binding var document: Document
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 0) {
                // Loops through every page to display the full document
                ForEach($document.pages) { $page in
                    // Each page renders its contents natively with its A4 ratio
                    ZStack {
                        // Put whatever represents your page's content/background here, 
                        // matching your editor view exactly.
                    }
                    .aspectRatio(1 / 1.4142, contentMode: .fit)
                }
            }
            .padding(20)
        }
    }
}

