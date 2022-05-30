import UIKit
import SnapKit

class OnBoardingUIView: UIView, UIScrollViewDelegate {
    
    // Create background image
    private let bigLogo: UIImageView = {
        let image = UIImageView()
        image.image = Asset.onBoardingNetflix.image
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    // Create blur view for image
    private let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(bigLogo)
        addSubview(blurView)
    }
    
    // Set constatints
    private func applyConstraints() {
        bigLogo.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
        }
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
