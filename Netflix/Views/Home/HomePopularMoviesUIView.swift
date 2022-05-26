import UIKit
import SnapKit

class HomePopularMoviesUIView: UIView {
    private let categoryName: UILabel = {
        let text = UILabel()
        text.text = "Popular Movies"
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        text.textColor = .white
        return text
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(categoryName)
        applyConstraints()
    }
    private func applyConstraints() {
        categoryName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }
    private let dataTest = [UIColor.red, UIColor.green, UIColor.blue,
                            UIColor.yellow, UIColor.white, UIColor.cyan]
    required init?(coder: NSCoder) {
        fatalError()
    }
}
