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
        
        let inputValidating = Observable.combineLatest(
            input.login.startWith(""),
            input.password.startWith("")
        ) { login, password in
            return login.count >= 1  && password.count >= 4
        }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
        
        let accessCheck = input.loginTrigger
            .withLatestFrom(inputValidating)
            .filter { $0 }
            .flatMapLatest { [apiClient] _ in
                apiClient.getToken()
            }
            .flatMapLatest { tokenResponse in
                UserDefaultsUseCase().token = tokenResponse.requestToken
            }
            .withLatestFrom(Observable.combineLatest(
                input.login.startWith(""),
                input.password.startWith("")
            ))
            .flatMapLatest({ [apiClient] (login, password) in
                let model = LoginPostResponseModel(
                    username: login,
                    password: password,
                    requestToken: UserDefaultsUseCase().token)
                apiClient.authenticationWithLoginPassword(model: model)
            })
            .flatMapLatest({ [apiClient] _ in
                let model = SessionIdPostResponseModel(
                    token: UserDefaultsUseCase().token)
                apiClient.getSessionId(model: SessionIdPostResponseModel)
            })
            .flatMapLatest({ sessionIDResponse in
                UserDefaultsUseCase().sessionId = sessionIDResponse.sessionID
                self.didSendEventClosure?(.main)
            })
            .asDriver(onErrorJustReturn: ())
        
        let showHidePassword = input.showHidePasswordTrigger
            .asDriver(onErrorJustReturn: ())
        
        let accessDenied = errorHandling
            .asDriver(onErrorJustReturn: "")
        
        return Output(
            inputValidating: inputValidating,
            accessCheck: accessCheck,
            showHidePassword: showHidePassword,
            accessDenied: accessDenied)
    }
    
    func saveKeyChain(login: String, password: String) {
        do {
            try KeyChainUseCase().saveLoginAndPassword(login: login, password: password.data(using: .utf8)!)
        } catch {
            print("KEYCHAIN SAVE \(error)")
        }
    }
}
