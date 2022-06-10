import Foundation
import RxCocoa
import RxSwift

class APIClient {
    static var shared = APIClient()
    lazy var requestObservable = APIRequest(config: .default)
    
    func getToken() throws -> Observable<[TokenResponseModel]> {
        var request = URLRequest(url:
                                    URL(string: "https://api.themovied.org/3/authentication/token/new?api_key=978a9c4ffdf0c73cd042eb5cd6607c8e")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField:
                            "Content-Type")
        return requestObservable.callAPI(request: request)
    }
    
//    func sendPost(loginModel: LoginResponseModel) -> Observable<LoginResponseModel> {
//        var request = URLRequest(url:
//                                    URL(string: "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=978a9c4ffdf0c73cd042eb5cd6607c8e")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField:
//                            "Content-Type")
//        let payloadData = try? JSONSerialization.data(withJSONObject:
//                                                        loginModel.dictionaryValue!, options: [])
//        request.httpBody = payloadData
//        return requestObservable.callAPI(request: request)
//    }
}

// Extension for converting out Model to jsonObject
// fileprivate extension Encodable {
//    var dictionaryValue: [String: Any?]? {
//        guard let data = try? JSONEncoder().encode(self),
//              let dictionary = try? JSONSerialization.jsonObject(
//                with: data,
//                options: .allowFragments) as? [String: Any] else {
//            return nil
//        }
//        return dictionary
//    }
// }
