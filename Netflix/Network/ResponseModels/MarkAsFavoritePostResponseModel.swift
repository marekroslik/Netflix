import Foundation

struct MarkAsFavoritePostResponseModel: Codable {
    let mediaType: String
    let mediaID: Int
    let favorite: Bool
    
    init(mediaType: String, mediaID: Int, favorite: Bool ) {
        self.mediaType = mediaType
        self.mediaID = mediaID
        self.favorite = favorite
    }
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case favorite
    }
}
