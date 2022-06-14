import Foundation
import RxSwift
import RxCocoa

public class APIRequest {
    private lazy var jsonDecoder = JSONDecoder()
    private let urlSession: URLSession
    public init(config: URLSessionConfiguration) {
        urlSession = URLSession(configuration:
                                    URLSessionConfiguration.default)
    }
    
    // Function for URLSession takes
    public func callAPI<ItemModel: Decodable>(request: URLRequest)
    -> Observable<ItemModel> {
       
        // Creating our observable
        return Observable.create { observer in
            
            // Create URLSession dataTask
            let task = self.urlSession.dataTask(with: request) { [weak self] (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    do {
                        let data = data ?? Data()
                        if (200...399).contains(statusCode) {
                            let objs = try self?.jsonDecoder.decode(ItemModel.self, from:
                                                                    data)
                            // Observer onNext event
                            observer.onNext(objs!)
                        } else if statusCode == 401 {
                            observer.onError(APIError.wrongPassword)
                        } else {
                            observer.onError(error!)
                        }
                    } catch {
                        
                        // Observer onNext event
                        observer.onError(error)
                    }
                }
                
                // Observer onCompleted event
                observer.onCompleted()
            }
            task.resume()
            
            // Return disposable
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
