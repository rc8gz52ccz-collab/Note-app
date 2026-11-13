import SwiftUI

struct ContentView: View {
    @StateObject private var docManager = DocumentManager()
    @State private var activeTab: Int = 1
    
    @State private var selectedFolderID: Folder.ID?
    @State private var selectedDocumentID: Document.ID?

    var selectedFolder: Folder? {
        docManager.folders.first(where: { $0.id == selectedFolderID }) ?? docManager.folders.first
    }

    func bindingForSelectedDocument() -> Binding<Document>? {
        for folderIndex in docManager.folders.indices {
            if let documentIndex = docManager.folders[folderIndex].documents.firstIndex(where: { $0.id == selectedDocumentID }) {
                return $docManager.folders[folderIndex].documents[documentIndex]
            }
        }
        if let folderIndex = docManager.folders.indices.first,
           let documentIndex = docManager.folders[folderIndex].documents.indices.first {
            return $docManager.folders[folderIndex].documents[documentIndex]
        }
        return nil
    }
    
    let neonBlue = Color(red: 0.2, green: 0.7, blue: 1.0)
    let neonPink = Color(red: 0.8, green: 0.3, blue: 0.7)
    
    var body: some View {
        ZStack {
            //temporary full screen page
            if activeTab == 4 {
                // Check if we have a valid document binding and at least one page exists
                if let docBinding = bindingForSelectedDocument() {
                    if docBinding.wrappedValue.pages.isEmpty {
                        // Safety fallback: auto-add a page if the document is empty so it doesn't render blank
                        let _ = DispatchQueue.main.async {
                            docBinding.wrappedValue.pages.append(Page())
                        }
                    }
                    
                    if let firstPageIndex = docBinding.wrappedValue.pages.indices.first {
                        PageView(
                            activeTab: $activeTab,
                            page: docBinding.pages[firstPageIndex],
                            document: docBinding
                        )
                        .ignoresSafeArea()
                    }
                } else {
                    Text("No document selected for Tab 4")
                        .foregroundColor(.white)
                }
            }
            
            else if activeTab == 3 {
                if let docBinding = bindingForSelectedDocument() {
                    editDocView(activeTab: $activeTab, document: docBinding)
                        .transition(.opacity)
                } else {
                    Text("Intet document valgt")
                        .foregroundColor(.clear)
                }
            } else { 
                if let docBinding = bindingForSelectedDocument() {
                    DocumentPagesScrollView(document: docBinding)
                }
                
                ZStack(alignment: .top) {
                    // 1. Deep Space Background & Planet Curve
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
                        // Top Global Bar: Smooth gradual fade centered over the gap
                        NeonPanel(
                            height: 52,
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
                            }
                            .frame(maxWidth: .infinity, maxHeight: 52, alignment: .top)
                            .zIndex(1)
                        }
                        
                        // Main Workspace Split with Panel Corner Icons Overlay
                        ZStack(alignment: .top) {
                            HStack(spacing: 12) {
                                // Left Sidebar Panel (Framed outline with transparent folder list overlay)
                                ZStack(alignment: .topLeading) {
                                    NeonPanel(
                                        width: 260,
                                        neonPink: neonPink,
                                        neonBlue: neonBlue,
                                        hasFill: false
                                    )
                                    // Transparent overlay showing folder list
                                    ScrollView(.vertical, showsIndicators: false) {
                                        VStack(alignment: .leading, spacing: 12) {
                                            ForEach(docManager.folders) { folder in
                                                Button(action: {
                                                    selectedFolderID = folder.id
                                                }) {
                                                    HStack(spacing: 12) {
                                                        Image(systemName: selectedFolderID == folder.id ? "folder.fill" : "folder")
                                                            .font(.system(size: 30, weight: .thin))
                                                            .foregroundStyle(
                                                                LinearGradient(
                                                                    colors: folder.gradientColors,
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                )
                                                            )
                                                        Text(folder.name)
                                                            .font(.system(size: 14))
                                                            .foregroundColor(.white)
                                                        Spacer()
                                                    }
                                                }
                                                .buttonStyle(.plain)
                                            }
                                        }
                                        .padding(.top, 76)
                                        .padding(.horizontal, 24)
                                        .padding(.bottom, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .frame(width: 260)
                                }
                                .overlay(alignment: .topTrailing) {
                                    Button(action: {
                                        let newFolder = Folder(name: "New Folder", documents: [
                                            Document(title: "Untitled Document", pages: [Page()])
                                        ])
                                        docManager.folders.append(newFolder)
                                        if selectedFolderID == nil {
                                            selectedFolderID = newFolder.id
                                        }
                                    }) {
                                        Image(systemName: "folder.badge.plus")
                                            .font(.system(size: 30, weight: .thin))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [neonPink, neonBlue],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .padding(10)
                                    }
                                    .offset(x: -6.7, y: 3.2)
                                    .buttonStyle(.plain)
                                }
                                // Right Content Area: Unified Outer Frame wrapping both pages
                                NeonPanel(
                                    neonPink: neonPink,
                                    neonBlue: neonBlue,
                                    hasFill: true
                                ) {
                                    GeometryReader { panelGeo in 
                                        let H = panelGeo.size.height
                                        
                                        VStack(spacing: 5) {
                                            // Permanent Top Content Workspace 
                                            ScrollView(.vertical, showsIndicators: false) {
                                                HStack(spacing: 13) {
                                                    if let folder = selectedFolder {
                                                        ForEach(folder.documents) { document in
                                                            Button(action: {
                                                                selectedDocumentID = document.id
                                                                withAnimation { 
                                                                    activeTab = 2 
                                                                }
                                                            }) {
                                                                VStack(spacing: 6) {
                                                                    Image(systemName: selectedDocumentID == document.id ? "doc.fill" : "doc")
                                                                        .font(.system(size: 50, weight: .ultraLight))
                                                                        .foregroundStyle(
                                                                            LinearGradient(
                                                                                colors: document.gradientColors,
                                                                                startPoint: .topLeading,
                                                                                endPoint: .bottomTrailing
                                                                            )
                                                                        )
                                                                    Text(document.title)
                                                                        .font(.system(size: 14))
                                                                        .foregroundColor(.white)
                                                                }
                                                            }
                                                            .buttonStyle(.plain)
                                                        }
                                                    }
                                                }
                                                .padding(.horizontal, 24)
                                                .padding(.top, 70)
                                                .padding(.bottom, 24)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .frame(height: H * 0.3) // Forces the top section to occupy exactly the designated proportion
                                            .mask(
                                                Group {
                                                    if activeTab == 2 {
                                                        LinearGradient(
                                                            stops: [
                                                                .init(color: Color.black, location: 0.0),
                                                                .init(color: Color.black, location: 0.6),
                                                                .init(color: Color.clear, location: 1.0)
                                                            ],
                                                            startPoint: .top,
                                                            endPoint: .bottom
                                                        )
                                                    } else {
                                                        Color.white
                                                    }
                                                }
                                            )
                                            
                                            // 2. Page 2 Content (Strictly takes the bottom portion, slides up when currentPage == 2)
                                            if activeTab == 2 {
                                                VStack(spacing: 0) {
                                                    // Faded Horizontal Neon Divider
                                                    LinearGradient(
                                                        stops: [
                                                            .init(color: Color.clear, location: 0.0),
                                                            .init(color: neonPink, location: 0.25),
                                                            .init(color: neonBlue, location: 0.75),
                                                            .init(color: Color.clear, location: 1.0)
                                                        ],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    ) 
                                                    .frame(height: 1.5)
                                                    .padding(.horizontal, 32)
                                                    .allowsHitTesting(false)
                                                    
                                                    // Scrollable A4 Document Previewer Area
                                                    ZStack(alignment: .topTrailing) {
                                                        ScrollView(.vertical, showsIndicators: false) {
                                                            VStack(spacing: 0) {
                                                                // A4 Sheet Element
                                                                ZStack {
                                                                    if let docBinding = bindingForSelectedDocument() {
                                                                        // Reuse your full editView directly here!
                                                                        DocumentPagesScrollView(document: docBinding)
                                                                    } else {
                                                                        Text("Select a document")
                                                                            .foregroundColor(.white.opacity(0.0))
                                                                            .italic()
                                                                    }

                                                                }
                                                                .frame(maxWidth: .infinity)
                                                                .aspectRatio(1 / 1.4142, contentMode: .fit)
                                                                
                                                                Spacer(minLength: 16)
                                                            }
                                                        }
                                                        
                                                        // Overlay Action Buttons (Export Pop-down Menu & Full Page Editor Trigger)
                                                        HStack(spacing: 12) {
                                                            // Export Menu Button
                                                            Menu {
                                                                Button(action: {
                                                                    // Action for exporting as high-res PDF
                                                                }) {
                                                                    Label("Export to PDF", systemImage:  "doc.text.fill")
                                                                }
                                                                
                                                                Button(action: {
                                                                    // Action for printing document
                                                                }) {
                                                                    Label("Print Document", systemImage: "printer")
                                                                }
                                                            } label: {
                                                                Image(systemName: "square.and.arrow.up")
                                                                    .font(.system(size: 16, weight: .medium))
                                                                    .foregroundStyle(
                                                                        LinearGradient(
                                                                            colors: [neonPink, neonBlue],
                                                                            startPoint: .topLeading,
                                                                            endPoint: .bottomTrailing
                                                                        )
                                                                    )
                                                                    .padding(8)
                                                                    .background(Color.white.opacity(0.08))
                                                                    .clipShape(Circle())
                                                            }
                                                            .buttonStyle(.plain)
                                                            
                                                            // Edit Document Button (Opens new page)
                                                            Button(action: {
                                                                withAnimation {
                                                                    activeTab = 3
                                                                }
                                                            }) {
                                                                Image(systemName: "pencil.and.outline")
                                                                    .font(.system(size: 16, weight: .medium))
                                                                    .foregroundStyle(
                                                                        LinearGradient(
                                                                            colors: [neonPink, neonBlue],
                                                                            startPoint: .topLeading,
                                                                            endPoint: .bottomTrailing
                                                                        )
                                                                    )
                                                                    .padding(8)
                                                                    .background(Color.white.opacity(0.08))
                                                                    .clipShape(Circle())
                                                            }
                                                            .buttonStyle(.plain)
                                                        }
                                                        .padding(.top, 16)
                                                        .padding(.trailing, 32)
                                                        .zIndex(10)
                                                    }
                                                    .frame(height: (H * 0.7) - 1.5)
                                                    
                                                }
                                                .frame(height: H * 0.7)
                                                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                                            }
                                        }
                                        .background(Color(red: 0.08, green: 0.08, blue: 0.10)
                                            .allowsHitTesting(false)
                                        )
                                    }
                                    
                                }
                                .overlay(alignment: .topLeading) {
                                    Button(action: {
                                        if let folderIndex = docManager.folders.firstIndex(where: { $0.id == selectedFolderID }) {
                                            let newDoc = Document(
                                                title: "New Document", 
                                                pages: [Page()]
                                            )
                                            docManager.folders[folderIndex].documents.append(newDoc)
                                            selectedDocumentID = newDoc.id
                                        }
                                    }) {
                                        Image(systemName: "doc.badge.plus")
                                            .font(.system(size: 30, weight: .thin))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [neonPink, neonBlue],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .padding(10)
                                    }
                                    .offset(x: 6.7, y: 1.4)
                                    .buttonStyle(.plain)
                                }
                            }
                            
                            // Floating Top Corner Buttons Overlay matching panel layouts
                            HStack(alignment: .center) {
                                // Left Sidebar Top Corner Button (Multi-Document Grid Icon)
                                Button(action: {
                                    withAnimation {
                                        activeTab = 1
                                    }
                                }) {
                                    ZStack(alignment: .center) {
                                        Image(systemName: "rectangle.portrait")
                                            .font(.system(size: 42, weight: .ultraLight))
                                        
                                        VStack(spacing: 0.5) {
                                            HStack(spacing: 1) {
                                                Image(systemName: "folder").offset(x: -3.3)
                                            }
                                            HStack(spacing: 1) {
                                                Image(systemName: "folder").offset(x: -3.3)
                                            }
                                            HStack(spacing: 1) {
                                                Image(systemName: "folder").offset(x: 3).rotationEffect(.degrees(-10))
                                            }
                                        }
                                        .font(.system(size: 10, weight: .light))
                                    }
                                    .offset(x: -11.5, y: -9.3)
                                    .font(.system(size: 30, weight: .thin))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [neonPink, neonBlue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .padding(10)
                                }
                                .buttonStyle(.plain)
                                .padding(.leading, 12)
                                
                                Spacer()
                                
                                // Right Content Panel Top Corner Button
                                Button(action: {
                                    withAnimation {
                                        activeTab = 2
                                    }
                                }) {
                                    ZStack(alignment: .center) {
                                        Image(systemName: "rectangle")
                                            .font(.system(size: 42, weight: .ultraLight))
                                        
                                        VStack(spacing: 1) {
                                            HStack(spacing: 0.7) {
                                                Image(systemName: "doc")
                                                    .offset(x: 0.35)
                                                Image(systemName: "doc")
                                                    .offset(x: -0.15)
                                                Image(systemName: "doc")
                                                    .rotationEffect(.degrees(22))
                                                    .offset(x: 0.19)
                                            }
                                        }
                                        .font(.system(size: 11.5, weight: .light))
                                    }
                                    .offset(x: 0.9, y: -11.8)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [neonPink, neonBlue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .padding(10)
                                }
                                .buttonStyle(.plain)
                                .padding(.leading, 12)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                            .zIndex(5)
                        }
                    }
                    .padding(12)
                }
            }
            
            //temporary pageview button
            if activeTab != 4 {
                Button(action: {
                    withAnimation {
                        activeTab = 4
                    }
                }) {
                    Label("Open Full-Screen Page (Tab 4)", systemImage: "doc.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}

