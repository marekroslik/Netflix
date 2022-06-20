import Foundation
import UIKit

class HomeViewModel {
    
    func logOut(didSendEventClosure: ((HomeViewController.Event) -> Void)?) {
        deleteKetChain()
        didSendEventClosure?(.logout)
    }
    
    func showMovieDetails(didSendEventClosure: ((HomeViewController.Event) -> Void)?) {
        didSendEventClosure?(.movieDetails)
    }
    
    func deleteKetChain() {
        do {
            try KeyChainUseCase.deleteLoginAndPassword()
        } catch {
            print("KEYCHAIN DELETE \(error)")
        }
    }
}
