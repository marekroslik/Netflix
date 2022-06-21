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
        let posterPath: String?
        let adult: Bool?
        let overview, releaseDate: String?
        let genreIDS: [Int]?
        let id: Int?
        let originalTitle, originalLanguage, title: String?
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
