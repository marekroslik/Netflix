import Foundation

struct SessionIdPostResponseModel: Codable {
    let requestToken: String

    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
    
    init(token: String) {
        self.requestToken = token
    }
}
