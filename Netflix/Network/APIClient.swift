import Foundation
import RxCocoa
import RxSwift

protocol APIClientProtocol {
    func getToken() -> Observable<TokenResponseModel>
    func authenticationWithLoginPassword(model: LoginPostResponseModel) -> Observable<LoginResponseModel>
    func getSessionId(model: SessionIdPostResponseModel) -> Observable<SessionIdResponseModel> 
    func getLatestMovie() -> Observable<LatestMovieResponseModel>
    func getPopularMovies(atPage page: Int) -> Observable<PopularMoviesResponseModel>
    func getUpcomingMovies(atPage page: Int) -> Observable<UpcomingMoviesResponseModel>
    func searchMovies(atPage page: Int, withTitle title: String) -> Observable<SearchMoviesResponseModel>
    func getAccountDetails(withSessionID id: String) -> Observable<AccountDetailsResponseModel>
    func getFavoritesMovies(atPage page: Int, withSessionId id: String) -> Observable<FavoritesMoviesResponseModel>
    func markAsFavorite(model: MarkAsFavoritePostResponseModel, withSessionId id: String) -> Observable<MarkAsFavoriteResponseModel>
}

class APIClient: APIClientProtocol {
    let requestObservable = APIRequest(config: .default)
    
    // Get token request
    func getToken() -> Observable<TokenResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.getToken +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey
        
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.GET.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HTTPHeaderField.contentType.rawValue)
        return requestObservable.callAPI(request: request)
    }
    
    // Login with password request
    func authenticationWithLoginPassword(model: LoginPostResponseModel) -> Observable<LoginResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.authenticationWithLoginPassword +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey
        
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.POST.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField:
                            APIConstants.HTTPHeaderField.contentType.rawValue)
        let payloadData = try? JSONEncoder().encode(model)
        request.httpBody = payloadData
        return requestObservable.callAPI(request: request)
    }
    
    func getSessionId(model: SessionIdPostResponseModel) -> Observable<SessionIdResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.sessionId +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey
        
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.POST.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField:
                            APIConstants.HTTPHeaderField.contentType.rawValue)
        let payloadData = try? JSONEncoder().encode(model)
        request.httpBody = payloadData
        return requestObservable.callAPI(request: request)
    }
    
    func getLatestMovie() -> Observable<LatestMovieResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.latestMovie +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey
        
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.GET.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HTTPHeaderField.contentType.rawValue)
        return requestObservable.callAPI(request: request)
    }
    
    func getPopularMovies(atPage page: Int) -> Observable<PopularMoviesResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.popularMovies +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey +
        APIConstants.ParamKeys.page +
        String(page)
        
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.GET.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HTTPHeaderField.contentType.rawValue)
        return requestObservable.callAPI(request: request)
    }
    
    func getUpcomingMovies(atPage page: Int) -> Observable<UpcomingMoviesResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.upcomingMovies +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey +
        APIConstants.ParamKeys.page +
        String(page)
        
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.GET.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HTTPHeaderField.contentType.rawValue)
        return requestObservable.callAPI(request: request)
    }
    
    func searchMovies(atPage page: Int, withTitle title: String) -> Observable<SearchMoviesResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.searchMovies +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey +
        APIConstants.ParamKeys.query +
        "%22\(title)%22" +
        APIConstants.ParamKeys.page +
        String(page)
        
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.GET.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HTTPHeaderField.contentType.rawValue)
        return requestObservable.callAPI(request: request)
    }
    
    func getAccountDetails(withSessionID id: String) -> Observable<AccountDetailsResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.account +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey +
        APIConstants.ParamKeys.sessionId +
        id
        
        var request = URLRequest(url: URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.GET.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HTTPHeaderField.contentType.rawValue)
        return requestObservable.callAPI(request: request)
    }
    
    func getFavoritesMovies(atPage page: Int, withSessionId id: String) -> Observable<FavoritesMoviesResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.favoritesMovies +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey +
        APIConstants.ParamKeys.sessionId +
        id +
        APIConstants.ParamKeys.page +
        String(page)
        
        var request = URLRequest(url: URL(string: urlRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = APIConstants.RequestType.GET.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HTTPHeaderField.contentType.rawValue)
        return requestObservable.callAPI(request: request)
    }
    
    func markAsFavorite(model: MarkAsFavoritePostResponseModel, withSessionId id: String) -> Observable<MarkAsFavoriteResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.account +
        APIConstants.Endpoint.favorite +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey +
        APIConstants.ParamKeys.sessionId +
        id
        
        print(urlRequest)
        
        var request = URLRequest(url: URL(string: urlRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = APIConstants.RequestType.POST.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField:
                            APIConstants.HTTPHeaderField.contentType.rawValue)
        let payloadData = try? JSONEncoder().encode(model)
        request.httpBody = payloadData
        return requestObservable.callAPI(request: request)
    }
}
