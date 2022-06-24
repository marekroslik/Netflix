import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    var didSendEventClosure: ((HomeViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    private let bag = DisposeBag()
    
    var latestMovie = PublishSubject<LatestMovieResponseModel>()
    var popularMovie = PublishSubject<PopularMoviesResponseModel>()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func logOut() {
        deleteKetChain()
        UserDefaultsUseCase().resetDefaults()
        didSendEventClosure?(.logout)
    }
    
    func showMovieDetails() {
        didSendEventClosure?(.movieDetails)
    }
    
    func deleteKetChain() {
        do {
            try KeyChainUseCase().deleteLoginAndPassword()
        } catch {
            print("KEYCHAIN DELETE \(error)")
        }
    }
    
    func getLatestMovie(bag: DisposeBag) {
        apiClient.getLatestMovie()
            .subscribe(onNext: { [weak self] result in
                self?.latestMovie.onNext(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
        
    }
    
    func getLPopularMovies(atPage page: Int, bag: DisposeBag) {
        apiClient.getPopularMovies(atPage: page)
            .subscribe(onNext: { [weak self] result in
                self?.popularMovie.onNext(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
}
