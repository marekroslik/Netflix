import UIKit
import SnapKit

class HomeHeaderUIView: UIView {
    private let logoView: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "SmallLogoNetflix")
        return logo
    }()
    private let accountButton: UIButton = {
        let button = UIButton()
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoView)
        addSubview(accountButton)
        applyConstraints()
    }
    private func applyConstraints() {
        logoView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(70)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        logoView.frame = bounds
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
