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

        // swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case id
            case posterPath = "poster_path"
        }
    }
}
