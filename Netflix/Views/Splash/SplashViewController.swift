import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController {
    
    // Create view
    private let splashView = SplashUIView()
    
    var viewModel: SplashViewModel!
    
    private let bag = DisposeBag()
    
    let userUseCase = UserUseCase()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        viewModel.timer(bag: bag)
        
        // Check UserUseCase
        userUseCase.tryToLoginWith(email: "email", password: "1234")
            .subscribe { event in
                switch event {
                case .success(let isLogin):
                    print("Access - , \(isLogin)")
                case .failure(let error):
                    print("failure , \(error)")
                }
            }.disposed(by: bag)
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(splashView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        splashView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
