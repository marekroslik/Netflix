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
        let showLoading: Driver<Void>
    }
    
    var didSendEventClosure: ((LoginViewController.Event) -> Void)?
    private var apiClient: APIClient
    private let keyChainUseCase: KeyChainUseCase
    private let userDefaultsUseCase: UserDefaultsUseCase
    
    private let bag = DisposeBag()
    private let errorHandling = PublishSubject<String>()
    
    init(
        apiClient: APIClient,
        keyChainUseCase: KeyChainUseCase,
        userDefaultsUseCase: UserDefaultsUseCase
    ) {
        self.apiClient = apiClient
        self.keyChainUseCase = keyChainUseCase
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let inputValidating = Observable.combineLatest(
            input.login.startWith(""),
            input.password.startWith("")
        ) { login, password in
            return login.count >= 1  && password.count >= 4
        }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        let showHidePassword = input.showHidePasswordTrigger
            .asDriver(onErrorJustReturn: ())
        
        let accessDenied = errorHandling
            .asDriver(onErrorJustReturn: "")
        
        let showLoading = input.loginTrigger
            .asDriver(onErrorJustReturn: ())
        
        let accessCheck = input.loginTrigger
            .withLatestFrom(inputValidating)
            .filter { $0 }
            .flatMapLatest { [apiClient, errorHandling] _ in
                apiClient.getToken()
                    .catch { _ in
                        errorHandling.onNext("Login failed. Please try again later")
                        return Observable.never()
                    }
            }
            .do(onNext: { [userDefaultsUseCase] tokenResponse in
                userDefaultsUseCase.token = tokenResponse.requestToken
            })
            .withLatestFrom(Observable.combineLatest(
                input.login.startWith(""),
                input.password.startWith("")
            ))
            .flatMapLatest { [apiClient, errorHandling, keyChainUseCase, userDefaultsUseCase] login, password -> Observable<LoginResponseModel> in
                let model = LoginPostResponseModel(
                    username: login,
                    password: password,
                    requestToken: userDefaultsUseCase.token!
                )
                try keyChainUseCase.deleteLoginAndPassword()
                try keyChainUseCase.saveLoginAndPassword(
                    login: login,
                    password: password.data(using: .utf8)!
                )
                return apiClient.authenticationWithLoginPassword(model: model)
                    .catch { error in
                        switch error {
                        case APIError.wrongPassword:
                            errorHandling.onNext("Invalid username or password")
                            return Observable.never()
                        default:
                            errorHandling.onNext("Login failed. Please try again later")
                            return Observable.never()
                        }
                    }
            }
            .flatMapLatest { [apiClient, errorHandling, userDefaultsUseCase] _ -> Observable<SessionIdResponseModel> in
                let model = SessionIdPostResponseModel(
                    token: userDefaultsUseCase.token!)
                return apiClient.getSessionId(model: model)
                    .catch { _ in
                        errorHandling.onNext("Login failed. Please try again later")
                        return Observable.never()
                    }
            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [didSendEventClosure, userDefaultsUseCase] sessionIdResponse in
                userDefaultsUseCase.sessionId = sessionIdResponse.sessionID
                didSendEventClosure?(.main)
            })
                .map { _ in () }
                .asDriver(onErrorJustReturn: ())
        
        return Output(
            inputValidating: inputValidating,
            accessCheck: accessCheck,
            showHidePassword: showHidePassword,
            accessDenied: accessDenied,
            showLoading: showLoading
        )
    }
}
