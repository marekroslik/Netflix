import UIKit

class FooterCollectionReusableView: UICollectionReusableView {
    static let identifier = "FooterCollectionReusableView"
    
    let tableSpinner: UIView = {
        let view = UIView()
        let spinner = UIActivityIndicatorView()
        spinner.color = .red
        spinner.transform = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        view.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        spinner.backgroundColor = .yellow
        spinner.startAnimating()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubview(tableSpinner)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableSpinner.frame = bounds
    }
}
