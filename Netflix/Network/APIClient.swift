import Foundation
import RxCocoa
import RxSwift

class APIClient {
    static var shared = APIClient()
    lazy var requestObservable = APIRequest(config: .default)
    
    // Get token request
    func getToken() throws -> Observable<TokenResponseModel> {
        let urlRequest =
        APIConstants.Api.baseUrl +
        APIConstants.Version.version3 +
        APIConstants.Endpoint.getToken +
        APIConstants.ParamKeys.apiKey +
        APIConstants.Api.apiKey
        var request = URLRequest(url:
                                    URL(string: urlRequest)!)
        request.httpMethod = APIConstants.RequestType.GET.rawValue
        request.addValue(APIConstants.ContentType.json.rawValue, forHTTPHeaderField: APIConstants.HTTPHeaderField.acceptType.rawValue)
        return requestObservable.callAPI(request: request)
    }
}
