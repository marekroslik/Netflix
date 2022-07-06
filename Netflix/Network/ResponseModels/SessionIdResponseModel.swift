import Foundation

struct SessionIdResponseModel: Codable {
    let success: Bool
    let sessionID: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}
