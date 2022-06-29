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
        bindViewModelInputs()
        bindViewModelOutputs()
        addButtonsAnimation(self.loginView.loginButton,
                            self.loginView.showHidePasswordButton,
                            disposeBag: bag)
    }
    
    private func bindViewModelInputs() {
        loginView
            .emailTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: bag)
        
        loginView
            .passwordTextField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: bag)
        
        loginView
            .loginButton
            .rx
            .tap
            .bind(to: viewModel.input.loginTrigger)
            .disposed(by: bag)
        
        loginView
            .showHidePasswordButton
            .rx
            .tap
            .bind(to: viewModel.input.showHidePasswordTrigger)
            .disposed(by: bag)
    }
    
    private func bindViewModelOutputs() {
        
        viewModel
            .output
            .inputValidating
            .drive(onNext: { [weak self] value in
                self?.loginView.loginButton.isEnabled = value
                self?.loginView.loginButton.alpha = (value ? 1 : 0.5)
            })
            .disposed(by: bag)
        
        viewModel
            .output
            .showHidePassword
            .drive(onNext: { [weak self] _ in
                self?.loginView.passwordTextField.isSecureTextEntry.toggle()
                if self?.loginView.passwordTextField.isSecureTextEntry == true {
                    self?.loginView.showHidePasswordButton.setTitle("SHOW", for: .normal)
                } else {
                    self?.loginView.showHidePasswordButton.setTitle("HIDE", for: .normal)
                }
            })
            .disposed(by: bag)
        
        viewModel
            .output
            .accessCheck
            .drive(onNext: { [weak self] _ in
                self?.loginView.loading.isHidden = false
        })
        .disposed(by: bag)
    }
    
    // Add subviews
    private func addSubviews() {
        view.addSubview(loginView)
    }
    
    // Set Constraints
    private func applyConstraints() {
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // Move view when keyboard is shown
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
    }
}

extension LoginViewController {
    enum Event {
        case main
    }
}
