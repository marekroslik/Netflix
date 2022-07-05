struct PopularMoviesResponseModel: Codable {
    let page: Int
    let results: [Result]
    let totalResults, totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
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
