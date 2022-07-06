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
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func transform(input: Input) -> Output {
        let getAccess = input.checkAccess
            .do(onNext: { [didSendEventClosure] _ in
                do {
                    _ = try KeyChainUseCase().getLoginAndPassword()
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
            .do(onNext: { tokenResponse in
                UserDefaultsUseCase().token = tokenResponse.requestToken
            })
            .flatMapLatest { [apiClient] model -> Observable<LoginResponseModel> in
                let model = LoginPostResponseModel(
                    username: try KeyChainUseCase().getLoginAndPassword().login,
                    password: try KeyChainUseCase().getLoginAndPassword().password,
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
            .flatMapLatest { [apiClient] _ -> Observable<SessionIdResponseModel> in
                let model = SessionIdPostResponseModel(
                    token: UserDefaultsUseCase().token!)
                return apiClient.getSessionId(model: model)
                    .catch { _ in
                        print("Internet error")
                        return Observable.never()
                    }
            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [didSendEventClosure] sessionIdResponse in
                print("save sessionId")
                UserDefaultsUseCase().sessionId = sessionIdResponse.sessionID
                didSendEventClosure?(.main)
            })
                .map({ _ in () })
                .asDriver(onErrorJustReturn: ())
        return Output(getAccess: getAccess)
    }
}
