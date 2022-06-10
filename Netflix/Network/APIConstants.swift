import Foundation

struct APIConstants {
    
    struct Api {
        static let baseUrl = "https://api.themoviedb.org"
        static let apiKey = "978a9c4ffdf0c73cd042eb5cd6607c8e"
        static let urlImages = "https://image.tmdb.org/t/p/w92"
    }
    
    struct Version {
        static let version3 = "/3/"
    }
    
    struct Endpoint {
        static let tokenWithLogin = "authentication/token/validate_with_login"
        static let popular = "movie/popular"
        static let detail = "movie/"
    }
    
    struct ParamKeys {
        static let apiKey = "api_key"
    }
    
    enum HTTPHeaderField: String {
        case acceptType = "Accept"
    }

    enum ContentType: String {
        case json = "application/json"
    }
}
