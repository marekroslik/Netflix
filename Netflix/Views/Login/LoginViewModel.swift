import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    struct Input {
        let login: Observable<String>
        let password: Observable<String>
        let loginTrigger: Observable<Void>
        let showHidePasswordTrigger: Observable<Void>
    }
    
    struct Output {
        let inputValidating: Driver<Bool>
        let accessCheck: Driver<Void>
        let showHidePassword: Driver<Void>
        let accessDenied: Driver<String>
    }
    
    var didSendEventClosure: ((LoginViewController.Event) -> Void)?
    private var apiClient: APIClient
    private let bag = DisposeBag()
    
    private let errorHandling = PublishSubject<String>()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func transform(input: Input) -> Output {
        let accessCheck = input.loginTrigger
            .withLatestFrom(Observable.combineLatest(input.login, input.password))
            .map { [ weak self] (login, password) in
                guard let self = self else { return }
                self.getToken(bag: self.bag)
                self.authenticationWithLoginPassword(login: login, password: password, bag: self.bag)
        }.asDriver(onErrorJustReturn: ())
        
        let inputValidating = Observable.combineLatest(input.login.startWith(""), input.password.startWith("")) { login, password in
            return login.count >= 1  && password.count >= 4
        }.startWith(false).asDriver(onErrorJustReturn: false)
        
        let showHidePassword = input.showHidePasswordTrigger.asDriver(onErrorJustReturn: ())
        
        let accessDenied = errorHandling.asDriver(onErrorJustReturn: "")
        
        return Output(
            inputValidating: inputValidating,
            accessCheck: accessCheck,
            showHidePassword: showHidePassword,
            accessDenied: accessDenied)
    }
    
    func getToken(bag: DisposeBag) {
            apiClient.getToken().subscribe(
                onNext: { result in
                    UserDefaultsUseCase().token = result.requestToken
                },
                onError: { [weak self] _ in
                    self?.errorHandling.onNext("Login failed. Please try again later")
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
