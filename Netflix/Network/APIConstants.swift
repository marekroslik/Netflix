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
        static let getToken = "authentication/token/new?"
        static let authenticationWithLoginPassword = "authentication/token/validate_with_login?"
    }
    
    struct ParamKeys {
        static let apiKey = "api_key="
    }
    
    enum HTTPHeaderField: String {
        case contentType = "Content-Type"
    }

    enum ContentType: String {
        case json = "application/json"
    }
    
    enum RequestType: String {
        case GET, POST
    }
}
