import Foundation

struct AccountDetailsResponseModel: Codable {
    let avatar: Avatar?
    let id: Int?
    let iso6391, iso31661, name: String?
    let includeAdult: Bool?
    let username: String?

    enum CodingKeys: String, CodingKey {
        case avatar, id
        case iso6391 = "iso_639_1"
        case iso31661 = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
   
    struct Avatar: Codable {
        let gravatar: Gravatar?
    }
    
    struct Gravatar: Codable {
        let hash: String?
    }
}
