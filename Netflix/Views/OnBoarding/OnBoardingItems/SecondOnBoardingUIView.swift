import UIKit
import SnapKit

class SecondOnBoardingUIView: UIView {
    
    // Create main label
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "That’s right!"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // Create info label
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Please go to the movieDB website and create an account there"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // Create singInButton
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = .red
        return button
    }()
    
    // Create singInButton
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN IN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = .red
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(mainLabel)
        addSubview(infoLabel)
        addSubview(signUpButton)
        addSubview(signInButton)
    }
    
    // Set constatints
    private func applyConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
      
        mainLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(infoLabel.snp.top).offset(-30)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(30)
        }
        
        signInButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }}
