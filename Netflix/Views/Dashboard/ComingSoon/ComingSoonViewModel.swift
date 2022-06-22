import Foundation
import RxSwift
import RxCocoa

class ComingSoonViewModel {
    var didSendEventClosure: ((ComingSoonViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    var comingSoon = PublishSubject<UpcomingMoviesResponseModel>()
    private let bag = DisposeBag()
    
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
}
