import Foundation

struct UpcomingMoviesResponseModel: Codable {
    let page: Int?
    let results: [Result]?
    let dates: Dates?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results, dates
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    struct Dates: Codable {
        let maximum, minimum: String?
    }
    
    struct Result: Codable {
        let id: Int
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
