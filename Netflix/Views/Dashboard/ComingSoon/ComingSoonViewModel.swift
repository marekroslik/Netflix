import Foundation
import RxSwift
import RxCocoa

class ComingSoonViewModel {
    var didSendEventClosure: ((ComingSoonViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    let comingSoon = PublishSubject<UpcomingMoviesResponseModel>()
    let searchMovies = PublishSubject<SearchMoviesResponseModel>()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getUpcomingMovies(atPage page: Int, bag: DisposeBag) {
        apiClient.getUpcomingMovies(atPage: page)
            .subscribe(onNext: { [weak self] result in
                self?.comingSoon.onNext(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
    
    func getSearchMovies(atPage page: Int, withTitle title: String, bag: DisposeBag) {
        apiClient.searchMovies(atPage: 1, withTitle: title)
            .subscribe(onNext: { [weak self] result in
                self?.searchMovies.onNext(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
}
