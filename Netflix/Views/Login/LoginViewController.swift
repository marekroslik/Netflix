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
        viewModel.getToken(bag: bag)
        loginButton()
        showHidePasswordButton()
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
    
    private func loginButton() {
        self.loginView.loginButton.rx.tap.bind {
            self.viewModel.authenticationWithLoginPassword(
                login: self.loginView.emailTextField.text!,
                password: self.loginView.passwordTextField.text!,
                bag: self.bag)
            self.loginView.showToast(message: "Wrong password")
            
            // Add animation
            self.loginView.loginButton.animateWhenPressed(disposeBag: self.bag)
        }.disposed(by: self.bag)
    }
    
    private func showHidePasswordButton() {
        self.loginView.showHidePasswordButton.rx.tap.bind {
            self.loginView.passwordTextField.isSecureTextEntry.toggle()
            if self.loginView.passwordTextField.isSecureTextEntry == true {
                self.loginView.showHidePasswordButton.setTitle("SHOW", for: .normal)
            } else { self.loginView.showHidePasswordButton.setTitle("HIDE", for: .normal) }
            // Add animation
            self.loginView.showHidePasswordButton.animateWhenPressed(disposeBag: self.bag)
        }.disposed(by: self.bag)
    }
    
    // Set Constraints
    private func applyConstraints() {
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
