struct PopularMoviesResponseModel: Codable {
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
        let id: Int?
        
        // swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case posterPath = "poster_path"
            case id
        }
    }
}
