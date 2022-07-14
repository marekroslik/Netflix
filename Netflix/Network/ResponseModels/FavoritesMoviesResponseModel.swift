import Foundation

struct FavoritesMoviesResponseModel: Codable {
    var page: Int
    var results: [Result]
    var totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    struct Result: Codable, Equatable, Hashable {
        var id: Int
        var posterPath: String?
        var title: String?
        var voteAverage: Double?
        var releaseDate: String?
        var overview: String?
        
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
