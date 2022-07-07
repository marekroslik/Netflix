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
        bindViewModel()
        addAnimation()
    }
    
    private func bindViewModel() {
        let inputs = LoginViewModel.Input(
            login: loginView.loginTextField.rx.text.orEmpty.asObservable(),
            password: loginView.passwordTextField.rx.text.orEmpty.asObservable(),
            loginTrigger: loginView.loginButton.rx.tap.asObservable(),
            showHidePasswordTrigger: loginView.showHidePasswordButton.rx.tap.asObservable()
        )
        let outputs = viewModel.transform(input: inputs)
        
        outputs.accessCheck
            .drive()
            .disposed(by: bag)
        
        outputs.inputValidating
            .drive(onNext: { [weak self] value in
                self?.loginView.loginButton.isEnabled = value
                self?.loginView.loginButton.alpha = (value ? 1 : 0.5)
            })
            .disposed(by: bag)
        
        outputs.showHidePassword
            .drive(onNext: { [weak self] _ in
                self?.loginView.passwordTextField.isSecureTextEntry.toggle()
                if self?.loginView.passwordTextField.isSecureTextEntry == true {
                    self?.loginView.showHidePasswordButton.setTitle("SHOW", for: .normal)
                } else {
                    self?.loginView.showHidePasswordButton.setTitle("HIDE", for: .normal)
                }
            })
            .disposed(by: bag)
        
        outputs.accessDenied
            .drive(onNext: { [weak self] text in
                self?.loginView.loading.isHidden = true
                self?.loginView.showToast(message: text)
            })
            .disposed(by: bag)
        
        outputs.showLoading
            .drive(onNext: { [weak self] bool in
                print(bool)
                self?.loginView.loading.isHidden = bool
            })
            .disposed(by: bag)
        
    }
    
    private func addAnimation() {
        addButtonsAnimation(self.loginView.loginButton,
                            self.loginView.showHidePasswordButton,
                            self.loginView.guestButton,
                            disposeBag: bag)
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
