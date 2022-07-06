import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType {
    
    struct Input {
        let closeViewTrigger: Observable<Void>
        let logoutTrigger: Observable<Void>
        let getInfo: Observable<Void>
    }
    
    struct Output {
        let closeView: Driver<Void>
        let logout: Driver<Void>
        let showInfo: Driver<AccountDetailsResponseModel?>
    }
    
    var didSendEventClosure: ((ProfileViewController.Event) -> Void)?
    
    private var apiClient: APIClient
    private let keyChainUseCase: KeyChainUseCase
    private let userDefaultsUseCase: UserDefaultsUseCase
    
    init(apiClient: APIClient, keyChainUseCase: KeyChainUseCase, userDefaultsUseCase: UserDefaultsUseCase) {
        self.apiClient = apiClient
        self.keyChainUseCase = keyChainUseCase
        self.userDefaultsUseCase = userDefaultsUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let closeView = input.closeViewTrigger
            .map({ [didSendEventClosure] _ in
                didSendEventClosure?(.close)
                return ()
            })
            .asDriver(onErrorJustReturn: ())
        
        let logout = input.logoutTrigger
            .map({ [didSendEventClosure, keyChainUseCase, userDefaultsUseCase] _ in
                do {
                    try keyChainUseCase.deleteLoginAndPassword()
                } catch {
                    print("KEYCHAIN DELETE \(error)")
                }
                userDefaultsUseCase.resetDefaults()
                didSendEventClosure?(.logout)
                return ()
            })
            .asDriver(onErrorJustReturn: ())
        
        let showInfo = input.getInfo
            .flatMapLatest({ [apiClient, userDefaultsUseCase] _ -> Observable<AccountDetailsResponseModel> in
                apiClient.getAccountDetails(withSessionID: userDefaultsUseCase.sessionId!)
            })
            .map { $0 as AccountDetailsResponseModel }
            .asDriver(onErrorJustReturn: nil)
        
        return Output(
            closeView: closeView,
            logout: logout,
            showInfo: showInfo
        )
    }
}
