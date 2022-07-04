import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    var didSendEventClosure: ((HomeViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    var latestMovie = PublishSubject<LatestMovieResponseModel>()
    var popularMovie = PublishSubject<PopularMoviesResponseModel>()
    
    var cellsData: PopularMoviesResponseModel?
    
    private var bag = DisposeBag()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func logOut() {
        deleteKetChain()
        UserDefaultsUseCase().resetDefaults()
        getToken(bag: bag)
        didSendEventClosure?(.logout)
    }
    
    func showMovieDetails(with id: Int) {
        didSendEventClosure?(.movieDetails(id: id))
    }
    
    func getToken(bag: DisposeBag) {
            apiClient.getToken().subscribe(
                onNext: { result in
                    UserDefaultsUseCase().token = result.requestToken
                },
                onError: { error in
                    print(error.localizedDescription)
                }).disposed(by: bag)
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
