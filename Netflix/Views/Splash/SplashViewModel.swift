import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel {
    
    private let countDown = 2
    private var loginAndPassword: (login: String, password: String)?
    private var token: String?
    var didSendEventClosure: ((SplashViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    private var latestMovie: LatestMovieResponseModel?
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func timer(bag: DisposeBag) {
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(countDown+1)
            .subscribe(onNext: { timePassed in
                let count = self.countDown - timePassed
                print(count)
            }, onCompleted: { [weak self] in
                guard let self = self else { return }
                
                // Trying to get data from KeyChain
                do {
                    self.loginAndPassword = try KeyChainUseCase().getLoginAndPassword()
                    self.tryToLogin(bag: bag)
                } catch {
                    // KeyChain error
                    self.didSendEventClosure?(.login)
                    return
                }
            }).disposed(by: bag)
    }
    
    func tryToLogin(bag: DisposeBag) {
        apiClient.getToken()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.token = result.requestToken
            },
                       onError: { _ in
                self.didSendEventClosure?(.login)
            }, onCompleted: { [weak self] in
                guard let self = self else { return }
                self.authenticationWithLoginPassword(
                    login: self.loginAndPassword!.login,
                    password: self.loginAndPassword!.password,
                    bag: bag)
            }).disposed(by: bag)
    }
    
    func authenticationWithLoginPassword(login: String, password: String, bag: DisposeBag) {
        let loginPost = LoginPostResponseModel(username: login, password: password, requestToken: self.token!)
        apiClient.authenticationWithLoginPassword(model: loginPost)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.didSendEventClosure?(.main)
            },
                       onError: { _ in
                self.didSendEventClosure?(.login)
            }).disposed(by: bag)
    }
    
    func getLatestMovie(bag: DisposeBag) {
        apiClient.getLatestMovie()
            .subscribe(onNext: { result in
                print(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
        
    }
    
    func getLPopularMovies(atPage page: Int, bag: DisposeBag) {
        apiClient.getPopularMovies(atPage: page)
            .subscribe(onNext: { result in
                print(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
    
    func getUpcomingMovies(atPage page: Int, bag: DisposeBag) {
        apiClient.getUpcomingMovies(atPage: page)
            .subscribe(onNext: { result in
                print(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
    
    func searchMovies(withTitle title: String, atPage page: Int, bag: DisposeBag) {
        apiClient.searchMovies(atPage: page, withTitle: title)
            .subscribe(onNext: { result in
                print(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
    
    func getAccountDetails(withSessionId id: String, bag: DisposeBag) {
        apiClient.getAccountDetails(withSessionID: id)
            .subscribe(onNext: { result in
                print(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
    
    func getFavoritesMovies(withAccountId id: String, atPage page: Int, bag: DisposeBag) {
        apiClient.getFavoritesMovies(atPage: page, withAccountId: id)
            .subscribe(onNext: { result in
                print(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
    
    func markAsFavorite(model: MarkAsFavoritePostResponseModel, withSessionId id: String, bag: DisposeBag) {
        apiClient.markAsFavorite(model: model, withSessionId: id)
            .subscribe(onNext: { result in
                print(result)
            }, onError: { error in
                print("Error \(error)")
            }).disposed(by: bag)
    }
    
}
