import UIKit
import SnapKit

final class ProfileUIView: UIView {
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
        
    }()
    
    private let horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
        image.clipsToBounds = true
        return image
    }()
    
    let loading: LoadingUIView = {
        let loading = LoadingUIView()
        loading.layer.cornerRadius = 50
        loading.clipsToBounds = true
        return loading
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "User"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private let memberLabel: UILabel = {
        let label = UILabel()
        label.text = "member".uppercased()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .red
        return label
    }()
    
    let mailLabel: UILabel = {
        let label = UILabel()
        label.text = "User@gmail.com"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()
    
    private let verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let pointLabel: UILabel = {
        let label = UILabel()
        label.text = "123"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let totalPointLabel: UILabel = {
        let label = UILabel()
        label.text = "Total points"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    let watchedLabel: UILabel = {
        let label = UILabel()
        label.text = "06"
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let moviesWatchedLabel: UILabel = {
        let label = UILabel()
        label.text = "Movies watched"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .gray
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = .red
        return button
    }()
    
    let loadingView = LoadingUIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(profileLabel)
        addSubview(exitButton)
        addSubview(horizontalLine)
        addSubview(profileImage)
        addSubview(loading)
        addSubview(nameLabel)
        addSubview(memberLabel)
        addSubview(mailLabel)
        addSubview(verticalLine)
        addSubview(pointLabel)
        addSubview(totalPointLabel)
        addSubview(watchedLabel)
        addSubview(moviesWatchedLabel)
        addSubview(logoutButton)
        addSubview(loadingView)
    }
    
    // Set constraints
    private func applyConstraints() {
        profileLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaInsets.top).offset(20)
            make.left.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaInsets.top).offset(20)
            make.right.equalToSuperview()
            make.size.equalTo(36)
        }
        
        horizontalLine.snp.makeConstraints { make in
            make.top.equalTo(profileLabel.snp.bottom).offset(20)
            make.height.equalTo(1)
            make.left.equalTo(profileLabel.snp.left)
            make.right.equalTo(exitButton.snp.right)
        }
        
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(horizontalLine.snp.bottom).offset(20)
            make.size.equalTo(100)
        }
        
        loading.snp.makeConstraints { make in
            make.edges.equalTo(profileImage)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(20)
            make.right.equalTo(verticalLine.snp.right).offset(-10)
            make.left.equalToSuperview().offset(10)
        }
        
        memberLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(20)
            make.left.equalTo(verticalLine.snp.right).offset(10)
        }
        
        mailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(memberLabel.snp.bottom).offset(20)
        }
        
        verticalLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mailLabel.snp.bottom).offset(20)
            make.height.equalTo(80)
            make.width.equalTo(1)
        }
        
        pointLabel.snp.makeConstraints { make in
            make.top.equalTo(verticalLine.snp.top)
            make.centerX.equalToSuperview().offset(-100)
        }
        
        totalPointLabel.snp.makeConstraints { make in
            make.bottom.equalTo(verticalLine.snp.bottom)
            make.centerX.equalToSuperview().offset(-100)
        }
        
        watchedLabel.snp.makeConstraints { make in
            make.top.equalTo(verticalLine.snp.top)
            make.centerX.equalToSuperview().offset(100)
        }
        
        moviesWatchedLabel.snp.makeConstraints { make in
            make.bottom.equalTo(verticalLine.snp.bottom)
            make.centerX.equalToSuperview().offset(100)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
