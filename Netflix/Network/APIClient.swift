import Foundation
import RxCocoa
import RxSwift

class APIClient {
    static var shared = APIClient()
    let requestObservable = APIRequest(config: .default)
    
    // Get token request
    func getToken() -> Observable<TokenResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.getToken +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey
        var request = URLRequest(url:
                                    URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.GET.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HTTPHeaderField.contentType.rawValue)
        return requestObservable.callAPI(request: request)
    }
    
    // Login with password request
    func authenticationWithLoginPassword(loginModel: LoginPostResponseModel) -> Observable<LoginResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.authenticationWithLoginPassword +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey
        var request = URLRequest(url:
                                    URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.POST.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField:
                            APIConstants.HTTPHeaderField.contentType.rawValue)
        let payloadData = try? JSONEncoder().encode(loginModel)
        request.httpBody = payloadData
        return requestObservable.callAPI(request: request)
    }
}
