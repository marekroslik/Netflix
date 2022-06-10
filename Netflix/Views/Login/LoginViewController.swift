import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    // Create view
    private let loginView = LoginUIView()
    var viewModel: LoginViewModel!
    
    var posts: [TokenResponseModel] = []
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubviews()
        applyConstraints()
        validating()
        
        // Check APIClient
        let client = APIClient.shared
        do {
            try client.getToken().subscribe(
                onNext: { result in
                    self.posts = result
                    // MARK: display in UITableView
//                    print(result)
                },
                onError: { error in
                    print("ATTENTION! ACHTUNG! УВАГА!  \(error.localizedDescription)")
                },
                onCompleted: {
                    print("Completed event.")
                }).disposed(by: bag)
        } catch {
        }
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
