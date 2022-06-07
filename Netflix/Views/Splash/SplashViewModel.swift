import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel {
    
    var coordinator: SplashCoordinator?
    
    private let countDown = 2
    
    func timer(bag: DisposeBag) {
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(countDown+1)
            .subscribe(onNext: { timePassed in
                let count = self.countDown - timePassed
                print(count)
            }, onCompleted: {
                let isLogin: Bool = UserUseCase().isUserLogin
                if isLogin {
                    print("Start dashboard")
                    self.coordinator?.startDashboard()
                } else {
                    print("Start on boarding")
                    self.coordinator?.startOnBoarding()
                }
            }).disposed(by: bag)
    }
}
