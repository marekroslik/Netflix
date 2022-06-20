import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel {
    
    private let countDown = 2
    private var loginAndPassword: (login: String, password: String)?
    private var token: String?
    var didSendEventClosure: ((SplashViewController.Event) -> Void)?
    
    func timer(bag: DisposeBag) {
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(countDown+1)
            .subscribe(onNext: { timePassed in
                let count = self.countDown - timePassed
                print(count)
            }, onCompleted: { [weak self] in
                guard let self = self else { return }
                
                // Trying to get data from KeyChain
                do {
                    self.loginAndPassword = try KeyChainUseCase.getLoginAndPassword()
                    self.tryToLogin(bag: bag)
                } catch {
                    // KeyChain error
                    self.didSendEventClosure?(.login)
                    return
                }
            }).disposed(by: bag)
    }
    
    func tryToLogin(bag: DisposeBag) {
        APIClient.shared.getToken()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.token = result.requestToken
            },
            onError: { _ in
                self.didSendEventClosure?(.login)
            }, onCompleted: { [weak self] in
                guard let self = self else { return }
                self.authenticationWithLoginPassword(
                    login: self.loginAndPassword!.login,
                    password: self.loginAndPassword!.password,
                    bag: bag)
            }).disposed(by: bag)
    }
    
    func authenticationWithLoginPassword(login: String, password: String, bag: DisposeBag) {
        let loginPost = LoginPostResponseModel(username: login, password: password, requestToken: self.token!)
        APIClient.shared.authenticationWithLoginPassword(loginModel: loginPost)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.didSendEventClosure?(.main)
            },
            onError: { _ in
                self.didSendEventClosure?(.login)
            }).disposed(by: bag)
    }
    
    // Functions to test KeyChain CRUD
    func saveKeyChain() {
        do {
            try KeyChainUseCase.saveLoginAndPassword(login: "marekqq", password: "marekqq".data(using: .utf8)!)
            print("KeyChain - SAVE")
            print("---------------")
        } catch {
            print("SAVE \(error)")
        }
    }
    func getKeyChain() {
        do {
            let loginAndPassword = try KeyChainUseCase.getLoginAndPassword()
            print("KeyChain - GET / login - \(loginAndPassword.login) password - \(loginAndPassword.password)")
            print("---------------")
        } catch {
            print("GET \(error)")
        }
    }
    
    func updateKeyChain() {
        do {
            try KeyChainUseCase.updateLoginAndPassword(login: "asdasd", password: "123")
            print("KeyChain - UPDATE")
            print("---------------")
        } catch {
            print("UPDATE \(error)")
        }
    }
    
    func deleteKetChain() {
        do {
            try KeyChainUseCase.deleteLoginAndPassword()
            print("KeyChain - DELETE")
            print("---------------")
        } catch {
            print("DELETE \(error)")
        }
    }
}
