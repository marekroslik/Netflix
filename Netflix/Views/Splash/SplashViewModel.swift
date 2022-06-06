import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel {
    
    var coordinator: SplashCoordinator?
    
    // Some var form userdefaults
    let isLogin: Bool = true
    
    func timer(countDown: Int, bag: DisposeBag) {
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(countDown+1)
            .subscribe(onNext: { timePassed in
                let count = countDown - timePassed
                print(count)
            }, onCompleted: {
                if self.isLogin == true {
                    print("Start dashboard")
                    self.coordinator?.startDashboard()
                } else {
                    print("Start on boarding")
                    self.coordinator?.startOnBoarding()
                }
            }).disposed(by: bag)
    }
}
