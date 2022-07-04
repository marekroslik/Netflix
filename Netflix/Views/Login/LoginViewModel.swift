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
    private let bag = DisposeBag()
    
    private let errorHandling = PublishSubject<String>()
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
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
            .do(onNext: { tokenResponse in
                UserDefaultsUseCase().token = tokenResponse.requestToken
            })
            .withLatestFrom(Observable.combineLatest(
                input.login.startWith(""),
                input.password.startWith("")
            ))
                .flatMapLatest { [apiClient, errorHandling] login, password -> Observable<LoginResponseModel> in
                    let model = LoginPostResponseModel(
                        username: login,
                        password: password,
                        requestToken: UserDefaultsUseCase().token!)
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
                .flatMapLatest { [apiClient, errorHandling] _ -> Observable<SessionIdResponseModel> in
                    let model = SessionIdPostResponseModel(
                        token: UserDefaultsUseCase().token!)
                    return apiClient.getSessionId(model: model)
                        .catch { _ in
                            errorHandling.onNext("Login failed. Please try again later")
                            return Observable.never()
                        }
                }
                .observe(on: MainScheduler.instance)
                .do(onNext: { [didSendEventClosure] sessionIdResponse in
                    UserDefaultsUseCase().sessionId = sessionIdResponse.sessionID
                    didSendEventClosure?(.main)
                })
                    .map { _ in () }
                    .asDriver(onErrorJustReturn: ())
        
        return Output(
            inputValidating: inputValidating,
            accessCheck: accessCheck,
            showHidePassword: showHidePassword,
            accessDenied: accessDenied,
            showLoading: showLoading)
    }
    
    func saveKeyChain(login: String, password: String) {
        do {
            try KeyChainUseCase().saveLoginAndPassword(login: login, password: password.data(using: .utf8)!)
        } catch {
            errorHandling.onNext("Login failed. Please try again later")
        }
    }
}
