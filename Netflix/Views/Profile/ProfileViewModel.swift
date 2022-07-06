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
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func transform(input: Input) -> Output {
        
        let closeView = input.closeViewTrigger
            .map({ [didSendEventClosure] _ in
                didSendEventClosure?(.close)
                return ()
            })
            .asDriver(onErrorJustReturn: ())
        
        let logout = input.logoutTrigger
            .map({ [didSendEventClosure] _ in
                do {
                    try KeyChainUseCase().deleteLoginAndPassword()
                } catch {
                    print("KEYCHAIN DELETE \(error)")
                }
                UserDefaultsUseCase().resetDefaults()
                didSendEventClosure?(.logout)
                return ()
            })
            .asDriver(onErrorJustReturn: ())
        
        let showInfo = input.getInfo
            .flatMapLatest({ [apiClient] _ -> Observable<AccountDetailsResponseModel> in
                apiClient.getAccountDetails(withSessionID: UserDefaultsUseCase().sessionId!)
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
