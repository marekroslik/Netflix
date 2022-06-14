import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel {
    
    private var coordinator: SplashCoordinator
    
    init (coordinator: SplashCoordinator) {
        self.coordinator = coordinator
    }
    
    private let countDown = 2
    
    func timer(bag: DisposeBag) {
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(countDown+1)
            .subscribe(onNext: { timePassed in
                let count = self.countDown - timePassed
                print(count)
            }, onCompleted: { [weak self] in
                
                self!.saveKeyChain()
                self!.getKeyChain()
                self!.updateKeyChain()
                self!.getKeyChain()
                self!.deleteKetChain()
                self!.getKeyChain()
                
                let isLogin: Bool = UserUseCase().isUserLogin
                if isLogin {
                    print("Start dashboard")
                    self!.coordinator.startDashboard()
                } else {
                    print("Start on boarding")
                    self!.coordinator.startOnBoarding()
                }
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
            try KeyChainUseCase.updateLoginAndPassword(login: "marekqq", password: "123")
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
