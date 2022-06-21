import Foundation

struct LatestMovieResponseModel: Codable {
    let adult: Bool?
    let backdropPath, belongsToCollection: String?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbID: String?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Int?
    let posterPath: String?
    let productionCompanies, productionCountries: [String]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [String]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage, voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    struct Genre: Codable {
        let id: Int?
        let name: String?
    }
}
