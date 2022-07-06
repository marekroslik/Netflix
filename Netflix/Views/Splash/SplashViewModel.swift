import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel: ViewModelType {
    
    struct Input {
        let checkAccess: Observable<Void>
    }
    
    struct Output {
        let getAccess: Driver<Void?>
    }
    
    var didSendEventClosure: ((SplashViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func transform(input: Input) -> Output {
        let getAccess = input.checkAccess
            .flatMapLatest { [apiClient] _ -> Observable<TokenResponseModel>in
                print("try to get token")
                return apiClient.getToken()
                    .catch { error in
                        print("token error - \(error)")
                        return Observable.never()
                    }
            }
            .do(onNext: { tokenResponse in
                print("save token")
                UserDefaultsUseCase().token = tokenResponse.requestToken
            })
            .flatMapLatest { [apiClient] model -> Observable<LoginResponseModel> in
                print("try to login")
                let model = LoginPostResponseModel(
                    username: try KeyChainUseCase().getLoginAndPassword().login,
                    password: try KeyChainUseCase().getLoginAndPassword().password,
                    requestToken: model.requestToken!
                )
                return apiClient.authenticationWithLoginPassword(model: model)
                    .catch { error in
                        print("login error - \(error)")
                        return Observable.never()
                    }
            }
            .flatMapLatest { [apiClient] _ -> Observable<SessionIdResponseModel> in
                print("try to get sessionId")
                let model = SessionIdPostResponseModel(
                    token: UserDefaultsUseCase().token!)
                return apiClient.getSessionId(model: model)
                    .catch { error in
                        print("sessin error - \(error)")
                        return Observable.never()
                    }
            }
            .do(onNext: { [didSendEventClosure] sessionIdResponse in
                print("save sessionId")
                UserDefaultsUseCase().sessionId = sessionIdResponse.sessionID
                didSendEventClosure?(.main)
            })
                .map({ _ in () })
                .asDriver(onErrorJustReturn: (self.didSendEventClosure?(.login)))
        return Output(getAccess: getAccess)
    }
}
