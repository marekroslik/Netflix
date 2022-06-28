import UIKit
import SnapKit

final class ComingSoonUIView: UIView {
    
    // Create category name for coming soon movies view
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .darkGray
        textField.textColor = .white
        textField.layer.cornerRadius = 5
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.paragraphStyle: centeredParagraphStyle, NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.font = .boldSystemFont(ofSize: 14)
        textField.setLeftPadding(10)
        textField.setRightPadding(10)
        textField.tintColor = .red
        return textField
    }()
    
    // Create collection view for coming soon movies view
    lazy var comingSoonCollectionView = UICollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews function
    private func addSubviews() {
        addSubview(searchTextField)
        configureCollectionView()
        addSubview(comingSoonCollectionView)
    }
    
    // Configure collection view for coming soon movies view
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        comingSoonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        comingSoonCollectionView.register(CustomComingSoonCollectionViewCell.self,
                                          forCellWithReuseIdentifier: CustomComingSoonCollectionViewCell.identifier)
        comingSoonCollectionView.showsVerticalScrollIndicator = false
        comingSoonCollectionView.backgroundColor = .black
    }
    
    // Set constraints function
    private func applyConstraints() {
        // Set search text field name constraints
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        // Set coming soon movies collection view
        comingSoonCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(15)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
