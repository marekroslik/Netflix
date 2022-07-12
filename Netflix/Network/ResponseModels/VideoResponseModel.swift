import Foundation

struct VideoResponseModel: Codable {
    let id: Int?
    let results: [Result]?
}
struct Result: Codable {
    let iso6391, iso31661, name, key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt, id: String?
    
    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case iso31661 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}
