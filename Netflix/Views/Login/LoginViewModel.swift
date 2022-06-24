import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    
    let emailTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    var errorHandling = PublishSubject<String>()
    
    var didSendEventClosure: ((LoginViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func isValid() -> Observable<Bool> {
        return Observable
            .combineLatest(emailTextPublishSubject.asObserver()
                .startWith(""), passwordTextPublishSubject.asObserver().startWith(""))
            .map { username, password in
                return username.count >= 1 && password.count >= 4
            }.startWith(false)
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
    
    func authenticationWithLoginPassword(
        login: String,
        password: String,
        bag: DisposeBag) {
        let loginPost = LoginPostResponseModel(
            username: login,
            password: password,
            requestToken: UserDefaultsUseCase().token!)
            apiClient.authenticationWithLoginPassword(model: loginPost )
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                self?.saveKeyChain(login: login, password: password)
                self?.getSessionId(token: UserDefaultsUseCase().token!, bag: bag)
            },
            onError: { [weak self] error in
                switch error {
                case APIError.wrongPassword:
                    self?.errorHandling.onNext("Invalid username or password")
                default:
                    self?.errorHandling.onNext("Login failed. Please try again later")
                }
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
                       onError: { [weak self] _ in
                self?.errorHandling.onNext("Login failed. Please try again later")
            }).disposed(by: bag)
    }
    
    func saveKeyChain(login: String, password: String) {
        do {
            try KeyChainUseCase().saveLoginAndPassword(login: login, password: password.data(using: .utf8)!)
        } catch {
            print("KEYCHAIN SAVE \(error)")
        }
    }
}
