import UIKit
import SnapKit

final class SplashUIView: UIView {
    
    // Cteate big logo
    private let bigLogo: UIImageView = {
        let image = UIImageView()
        image.image = Asset.bigLogoNetflix.image
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews
    private func addSubviews() {
        addSubview(bigLogo)
    }
    
    // Set constraints
    private func applyConstraints() {
        bigLogo.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
