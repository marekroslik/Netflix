import Foundation
import UIKit

class HomeViewModel {
    var didSendEventClosure: ((HomeViewController.Event) -> Void)?
    private var apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func logOut() {
        deleteKetChain()
        didSendEventClosure?(.logout)
    }
    
    func showMovieDetails() {
        didSendEventClosure?(.movieDetails)
    }
    
    func deleteKetChain() {
        do {
            try KeyChainUseCase().deleteLoginAndPassword()
        } catch {
            print("KEYCHAIN DELETE \(error)")
        }
    }
}
