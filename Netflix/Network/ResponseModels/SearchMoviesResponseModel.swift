import Foundation

struct SearchMoviesResponseModel: Codable {
    let page: Int?
    let results: [Result]?
    let totalResults, totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
    
    struct Result: Codable {
        let posterPath: String?
        let adult: Bool?
        let overview, releaseDate: String?
        let genreIDS: [Int]?
        let id: Int?
        let originalTitle: String?
        let originalLanguage: String?
        let title: String?
        let backdropPath: String?
        let popularity: Double?
        let voteCount: Int?
        let video: Bool?
        let voteAverage: Double?

        // swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case posterPath = "poster_path"
            case adult, overview
            case releaseDate = "release_date"
            case genreIDS = "genre_ids"
            case id
            case originalTitle = "original_title"
            case originalLanguage = "original_language"
            case title
            case backdropPath = "backdrop_path"
            case popularity
            case voteCount = "vote_count"
            case video
            case voteAverage = "vote_average"
        }
    }
}
