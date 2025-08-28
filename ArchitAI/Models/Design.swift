import SwiftUI

struct Design: Identifiable {
    let id: UUID
    let title: String
    let style: DesignStyle
    let room: Room
    let beforeImageData: Data?
    let afterImageData: Data?
    let beforeImageURL: String?
    let afterImageURL: String?
    let beforeImagePath: String?
    let afterImagePath: String?
    let createdAt: Date
    let userID: String?
    
    var beforeImage: UIImage? {
        if let imageData = beforeImageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    var afterImage: UIImage? {
        if let imageData = afterImageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}

// MARK: - Codable
extension Design: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case style
        case room
        case beforeImageData
        case afterImageData
        case beforeImageURL
        case afterImageURL
        case beforeImagePath
        case afterImagePath
        case createdAt
        case userID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        style = try container.decode(DesignStyle.self, forKey: .style)
        room = try container.decode(Room.self, forKey: .room)
        beforeImageData = try container.decodeIfPresent(Data.self, forKey: .beforeImageData)
        afterImageData = try container.decodeIfPresent(Data.self, forKey: .afterImageData)
        beforeImageURL = try container.decodeIfPresent(String.self, forKey: .beforeImageURL)
        afterImageURL = try container.decodeIfPresent(String.self, forKey: .afterImageURL)
        beforeImagePath = try container.decodeIfPresent(String.self, forKey: .beforeImagePath)
        afterImagePath = try container.decodeIfPresent(String.self, forKey: .afterImagePath)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        userID = try container.decodeIfPresent(String.self, forKey: .userID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(style, forKey: .style)
        try container.encode(room, forKey: .room)
        try container.encodeIfPresent(beforeImageData, forKey: .beforeImageData)
        try container.encodeIfPresent(afterImageData, forKey: .afterImageData)
        try container.encodeIfPresent(beforeImageURL, forKey: .beforeImageURL)
        try container.encodeIfPresent(afterImageURL, forKey: .afterImageURL)
        try container.encodeIfPresent(beforeImagePath, forKey: .beforeImagePath)
        try container.encodeIfPresent(afterImagePath, forKey: .afterImagePath)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(userID, forKey: .userID)
    }
}

// MARK: - Initialization
extension Design {
    init(
        id: UUID = UUID(),
        title: String,
        style: DesignStyle,
        room: Room,
        beforeImage: UIImage,
        afterImage: UIImage,
        userID: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.style = style
        self.room = room
        self.beforeImageData = beforeImage.jpegData(compressionQuality: 0.8)
        self.afterImageData = afterImage.jpegData(compressionQuality: 0.8)
        self.beforeImageURL = nil
        self.afterImageURL = nil
        self.beforeImagePath = nil
        self.afterImagePath = nil
        self.userID = userID
        self.createdAt = createdAt
    }
    
    // Firebase'den gelen design için init
    init(
        id: UUID = UUID(),
        title: String,
        style: DesignStyle,
        room: Room,
        beforeImageURL: String?,
        afterImageURL: String?,
        userID: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.style = style
        self.room = room
        self.beforeImageData = nil
        self.afterImageData = nil
        self.beforeImageURL = beforeImageURL
        self.afterImageURL = afterImageURL
        self.beforeImagePath = nil
        self.afterImagePath = nil
        self.userID = userID
        self.createdAt = createdAt
    }
}

