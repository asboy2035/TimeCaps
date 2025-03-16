//
//  CapsuleItem.swift
//  TImeCaps
//
//  Created by ash on 3/15/25.
//

import SwiftData
import SwiftUI

@Model
final class CapsuleItem {
    var id: UUID
    var type: ItemType
    var creationDate: Date
    var title: String
    var fileURL: URL?
    var text: String?
    var imageData: Data?
    var audioData: Data?
    
    init(type: ItemType, title: String) {
        self.id = UUID()
        self.type = type
        self.creationDate = Date()
        self.title = title
    }
    
    enum ItemType: String, Codable {
        case photo
        case text
        case audio
        case music
    }
}
