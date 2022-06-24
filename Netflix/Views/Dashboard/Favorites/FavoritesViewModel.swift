import Foundation
import RxSwift

class FavoritesViewModel {
    var didSendEventClosure: ((FavoritesViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    let favoritesMovies = PublishSubject<FavoritesMoviesResponseModel>()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getFavoritesMovies(atPage page: Int, withSessionId id: String, bag: DisposeBag) {
        apiClient.getFavoritesMovies(atPage: page, withSessionId: id)
            .subscribe(onNext: { result in
                self.favoritesMovies.onNext(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
}
