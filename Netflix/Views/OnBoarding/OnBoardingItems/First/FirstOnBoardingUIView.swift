import UIKit
import SnapKit

final class FirstOnBoardingUIView: UIView {
    
    // Create main label
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Trying to join NetflixDB?"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // Create info label
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = """
You can’t sign up Netflix in the app.
We know it’s a hassle.
After you’re a member, you can start watching in the app.
Scroll > to learn more
"""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        return label
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
    }
    
    // Set constatints
    private func applyConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
      
        mainLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(infoLabel.snp.top).offset(-30)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
