struct PopularMoviesResponseModel: Codable {
    var page: Int
    var results: [Result]
    var totalResults, totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
    
    struct Result: Codable {
        var id: Int
        var favorites: Bool = false
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
