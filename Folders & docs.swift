import Foundation
import SwiftUI
import PencilKit

class DocumentManager: ObservableObject {
    @Published var folders: [Folder] = [] {
        didSet {
            saveDocuments()
        }
    }
    
    private let storageKey = "SavedFoldersStorageKey"
    
    init() {
        loadDocuments()
    }
    
    func saveDocuments() {
        if let encoded = try? JSONEncoder().encode(folders) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func loadDocuments() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Folder].self, from: data) {
            folders = decoded
        } else {
            folders = [
                Folder(name: "Untitled Folder", documents: [
                    Document(title: "Untitled Document", pages: [Page()])
                ])
            ]
        }
    }
}

struct Folder: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var documents: [Document]
    
    var gradientColors: [Color] {
        return [
            Color(red: 0.8, green: 0.3, blue: 0.7),
            Color(red: 0.2, green: 0.7, blue: 1.0)
        ]
    }
    
    init(id: UUID = UUID(), name: String, documents: [Document]) {
        self.id = id
        self.name = name
        self.documents = documents
    }
}

struct Document: Identifiable, Hashable, Codable {
    var id: UUID
    var title: String
    var pages: [Page]
    
    var gradientColors: [Color] {
        return [
            Color(red: 0.8, green: 0.3, blue: 0.7),
            Color(red: 0.2, green: 0.7, blue: 1.0)
        ]
    }
    
    init(id: UUID = UUID(), title: String, pages: [Page] = [Page()]) {
        self.id = id
        self.title = title
        self.pages = pages
    }
}

struct Page: Identifiable, Codable, Hashable {
    var id: UUID
    var drawing: PKDrawing
    var latexAnnotations: [LaTeXAnnotation] = []
    
    init(id: UUID = UUID(), drawing: PKDrawing = PKDrawing(), latexAnnotations: [LaTeXAnnotation] = []) {
        self.id = id
        self.drawing = drawing
        self.latexAnnotations = latexAnnotations
    }
    
    // Custom CodingKeys including latexAnnotations
    enum CodingKeys: String, CodingKey {
        case id
        case drawingData
        case latexAnnotations // <-- Added here
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        
        if let data = try container.decodeIfPresent(Data.self, forKey: .drawingData),
           let decodedDrawing = try? PKDrawing(data: data) {
            drawing = decodedDrawing
        } else {
            drawing = PKDrawing()
        }
        
        // Decode annotations safely (defaults to empty array if missing)
        latexAnnotations = try container.decodeIfPresent([LaTeXAnnotation].self, forKey: .latexAnnotations) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        let data = drawing.dataRepresentation()
        try container.encode(data, forKey: .drawingData)
        
        // Encode annotations so they save with the document
        try container.encode(latexAnnotations, forKey: .latexAnnotations)
    }
    
    // Hashable conformance
    static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.id == rhs.id && 
        lhs.drawing.dataRepresentation() == rhs.drawing.dataRepresentation() &&
        lhs.latexAnnotations == rhs.latexAnnotations
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


