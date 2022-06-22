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
        let id: Int?

        // swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case posterPath = "poster_path"
            case id
        }
    }
}
