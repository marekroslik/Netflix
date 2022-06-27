import Foundation

struct FavoritesMoviesResponseModel: Codable {
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    struct Result: Codable {
        let id: Int?
        let posterPath: String?
        let title: String?
        let voteAverage: Double?
        let releaseDate: String?
        let overview: String?
        
        // swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case id
            case posterPath = "poster_path"
            case title
            case voteAverage = "vote_average"
            case releaseDate = "release_date"
            case overview
        }
    }
}
