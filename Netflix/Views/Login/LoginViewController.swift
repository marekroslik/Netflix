import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    // Create view
    private let loginView = LoginUIView()
    var viewModel: LoginViewModel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        validating()
        getToken()
    }
    
    // Move view when keyboard is shown
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(loginView)
    }
    
    // Get token function
    private func getToken() {
        let client = APIClient.shared
        do {
            try client.getToken().subscribe(
                onNext: { [weak self] result in
                    self?.viewModel.token = result
                },
                onError: { error in
                    print(error.localizedDescription)
                }).disposed(by: bag)
        } catch {
            print(error)
        }
    }
    
    // Validating email and password
    private func validating() {
        loginView.emailTextField.becomeFirstResponder()
        loginView.emailTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.emailTextPublishSubject).disposed(by: bag)
        loginView.passwordTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.passwordTextPublishSubject).disposed(by: bag)
        
        viewModel.isValid().bind(to: loginView.loginButton.rx.isEnabled).disposed(by: bag)
        viewModel.isValid().map { $0 ? 1 : 0.5}.bind(to: loginView.loginButton.rx.alpha).disposed(by: bag)
    }
    
    // Set Constraints
    private func applyConstraints() {
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
