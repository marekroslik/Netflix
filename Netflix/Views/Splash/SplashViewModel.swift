import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel {
    
    private let countDown = 2
    private var loginAndPassword: (login: String, password: String)?
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
            .subscribe(onNext: { result in
                // Add token to userdefault
                UserDefaultsUseCase().token = result.requestToken
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
        let loginPost = LoginPostResponseModel(username: login, password: password, requestToken: UserDefaultsUseCase().token!)
        apiClient.authenticationWithLoginPassword(model: loginPost)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.getSessionId(token: UserDefaultsUseCase().token!, bag: bag)
            },
                       onError: { _ in
                self.didSendEventClosure?(.login)
            }).disposed(by: bag)
    }
    
    func getSessionId(token: String, bag: DisposeBag) {
        let sessionIdPost = SessionIdPostResponseModel(token: token)
        apiClient.getSessionId(model: sessionIdPost)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { value in
                UserDefaultsUseCase().sessionId = value.sessionID
                self.didSendEventClosure?(.main)
            },
                       onError: { _ in
                self.didSendEventClosure?(.login)
            }).disposed(by: bag)
    }
}
