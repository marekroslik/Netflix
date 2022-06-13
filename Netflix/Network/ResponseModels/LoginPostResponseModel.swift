import Foundation

struct LoginPostResponseModel: Codable {
    let username: String
    let password: String
    let requestToken: String
    
    init(username: String, password: String, requestToken: String ) {
        self.username = username
        self.password = password
        self.requestToken = requestToken
    }

    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
        case requestToken = "request_token"
    }
}
