import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel: ViewModelType {
    
    struct Input {
        let checkAccess: Observable<Void>
    }
    
    struct Output {
        let getAccess: Driver<Void>
    }
    
    var didSendEventClosure: ((SplashViewController.Event) -> Void)?
    private let apiClient: APIClient
    private let keyChainUseCase: KeyChainUseCase
    private let userDefaultsUseCase: UserDefaultsUseCase
    
    init(apiClient: APIClient, keyChainUseCase: KeyChainUseCase, userDefaultsUseCase: UserDefaultsUseCase) {
        self.apiClient = apiClient
        self.keyChainUseCase = keyChainUseCase
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        let getAccess = input.checkAccess
            .do(onNext: { [didSendEventClosure, keyChainUseCase] _ in
                do {
                    _ = try keyChainUseCase.getLoginAndPassword()
                } catch {
                    didSendEventClosure?(.login)
                }
            })
            .flatMapLatest { [apiClient] _ -> Observable<TokenResponseModel>in
                return apiClient.getToken()
                    .catch { _ in
                        print("Internet error")
                        return Observable.never()
                    }
            }
            .do(onNext: { [userDefaultsUseCase] tokenResponse in
                userDefaultsUseCase.token = tokenResponse.requestToken
            })
            .flatMapLatest { [apiClient, keyChainUseCase] model -> Observable<LoginResponseModel> in
                let model = LoginPostResponseModel(
                    username: try keyChainUseCase.getLoginAndPassword().login,
                    password: try keyChainUseCase.getLoginAndPassword().password,
                    requestToken: model.requestToken!
                )
                return apiClient.authenticationWithLoginPassword(model: model)
                    .catch { [weak self] error in
                        switch error {
                        case APIError.wrongPassword:
                            print("Invalid username or password")
                            self?.didSendEventClosure?(.login)
                            return Observable.never()
                        default:
                            print("Internet error")
                            return Observable.never()
                        }
                    }
            }
            .flatMapLatest { [apiClient, userDefaultsUseCase] _ -> Observable<SessionIdResponseModel> in
                let model = SessionIdPostResponseModel(
                    token: userDefaultsUseCase.token!)
                return apiClient.getSessionId(model: model)
                    .catch { _ in
                        print("Internet error")
                        return Observable.never()
                    }
            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [didSendEventClosure, userDefaultsUseCase] sessionIdResponse in
                print("save sessionId")
                userDefaultsUseCase.sessionId = sessionIdResponse.sessionID
                didSendEventClosure?(.main)
            })
                .map({ _ in () })
                .asDriver(onErrorJustReturn: ())
        return Output(getAccess: getAccess)
    }
}
