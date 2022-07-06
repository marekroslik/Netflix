import Foundation

struct APIConstants {
    
    struct Api {
        static let baseUrl = "https://api.themoviedb.org"
        static let apiKey = "978a9c4ffdf0c73cd042eb5cd6607c8e"
        static let urlImages = "https://image.tmdb.org/t/p/w300"
        static let gravatarImage = "https://www.gravatar.com/avatar/"
    }
    
    struct Version {
        static let version3 = "/3/"
    }
    
    struct Endpoint {
        static let getToken = "authentication/token/new"
        static let authenticationWithLoginPassword = "authentication/token/validate_with_login"
        static let latestMovie = "movie/latest"
        static let popularMovies = "movie/popular"
        static let upcomingMovies = "movie/upcoming"
        static let favoritesMovies = "account/{account_id}/favorite/movies"
        static let searchMovies = "search/movie"
        static let account = "account"
        static let favorite = "favorite"
        static let sessionId = "authentication/session/new"
    }
    
    struct ParamKeys {
        static let apiKey = "?api_key="
        static let query = "&query="
        static let sessionId = "&session_id="
        static let page = "&page="
        static let gravataRetro = "?d=retro"
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
