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
    private let startTime = Date()
    
    init(apiClient: APIClient, keyChainUseCase: KeyChainUseCase, userDefaultsUseCase: UserDefaultsUseCase) {
        self.apiClient = apiClient
        self.keyChainUseCase = keyChainUseCase
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        let getAccess = input.checkAccess
            .do(onNext: { [didSendEventClosure, keyChainUseCase, startTime] _ in
                do {
                    _ = try keyChainUseCase.getLoginAndPassword()
                } catch {
                    let time = Date().timeIntervalSince(startTime)
                    if time < 2 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2 - time) {
                            didSendEventClosure?(.login)
                        }
                    } else {
                        didSendEventClosure?(.login)
                    }
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
            .flatMapLatest { [apiClient, keyChainUseCase, didSendEventClosure, startTime] model -> Observable<LoginResponseModel> in
                let model = LoginPostResponseModel(
                    username: try keyChainUseCase.getLoginAndPassword().login,
                    password: try keyChainUseCase.getLoginAndPassword().password,
                    requestToken: model.requestToken!
                )
                return apiClient.authenticationWithLoginPassword(model: model)
                    .observe(on: MainScheduler.instance)
                    .catch { [didSendEventClosure, startTime] error in
                        switch error {
                        case APIError.wrongPassword:
                            print("Invalid username or password")
                            let time = Date().timeIntervalSince(startTime)
                            if time < 2 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2 - time) {
                                    didSendEventClosure?(.login)
                                }
                            } else {
                                didSendEventClosure?(.login)
                            }
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
            .do(onNext: { [didSendEventClosure, userDefaultsUseCase, startTime] sessionIdResponse in
                userDefaultsUseCase.sessionId = sessionIdResponse.sessionID
                let time = Date().timeIntervalSince(startTime)
                if time < 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2 - time) {
                        didSendEventClosure?(.main)
                    }
                } else {
                    didSendEventClosure?(.main)
                }
            })
            .map({ _ in () })
                .asDriver(onErrorJustReturn: ())
                return Output(getAccess: getAccess)
                }
}
