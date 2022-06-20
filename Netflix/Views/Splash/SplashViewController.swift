import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController {
    
    // Create view
    private let splashView = SplashUIView()
    
    var didSendEventClosure: ((SplashViewController.Event) -> Void)?
    
    var viewModel: SplashViewModel!
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        viewModel.timer(bag: bag, didSendEventClosure: didSendEventClosure)
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

extension SplashViewController {
    enum Event {
        case login
        case main
    }
}
