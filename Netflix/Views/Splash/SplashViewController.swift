import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController {
    
    // Create view
    private let splashView = SplashUIView()
    
    var viewModel: SplashViewModel!
    
    private let bag = DisposeBag()
    let viewDidLoadRelay = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        bindViewModel()
        viewDidLoadRelay.accept(())
    }
    
    private func bindViewModel() {
        let inputs = SplashViewModel.Input(checkAccess: viewDidLoadRelay.asObservable())
        
        let outputs = viewModel.transform(input: inputs)
        
        outputs.getAccess.drive().disposed(by: bag)
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
