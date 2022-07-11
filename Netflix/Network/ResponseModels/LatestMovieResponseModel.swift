import Foundation

struct LatestMovieResponseModel: Codable {
    let id: Int
    var favorites: Bool = false
    let imdbID: String?
    let originalTitle: String?
    let posterPath: String?
    let tagline, title: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdb_id"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case tagline, title
    }
}
