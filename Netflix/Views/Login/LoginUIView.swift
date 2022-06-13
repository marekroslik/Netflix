import UIKit
import SnapKit

final class LoginUIView: UIView {
    
    // Cteate full logo
    private let fullLogo: UIImageView = {
        let image = UIImageView()
        image.image = Asset.fullLogoNetflix.image
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    // Create email text field
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.font = .boldSystemFont(ofSize: 14)
        textField.setLeftPadding(10)
        textField.setRightPadding(10)
        textField.tintColor = .red
        textField.textColor = .white
        return textField
    }()
    
    // Create password text field
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.layer.cornerRadius = 5
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.font = .boldSystemFont(ofSize: 14)
        textField.setLeftPadding(10)
        textField.setRightPadding(65)
        textField.isSecureTextEntry = true
        textField.tintColor = .red
        textField.textColor = .white
        return textField
    }()
    
    // Create login button
    let loginButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    // Create guest mode button
    private let guestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Guest Mode", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    // Create show/hide password button
    let showHidePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("SHOW", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
    let showAlert: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "Incorrect username or password"
        label.alpha = 0
        label.layer.cornerRadius = 5
        label.clipsToBounds  =  true
//        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(fullLogo)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(guestButton)
        addSubview(showHidePasswordButton)
        addSubview(showAlert)
    }
    
    func showToast(message: String) {
        self.showAlert.text = message
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.showAlert.alpha = 1
        }, completion: {(_) in
            UIView.animate(withDuration: 1.0, delay: 2, options: .curveEaseOut) {
                self.showAlert.alpha = 0
            }
        })
    }
    
    // Set constatints
    private func applyConstraints() {
        
        fullLogo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            
        }
        passwordTextField.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
        }
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(passwordTextField)
            make.bottom.equalTo(passwordTextField.snp.top).offset(-20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
        
        guestButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
        
        showHidePasswordButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.right.equalTo(passwordTextField.snp.right).offset(-10)
        }
        
        showAlert.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
