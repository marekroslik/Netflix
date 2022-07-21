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
    
    let comingSoonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    let searchMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    let searchEmptyText: UILabel = {
        let label = UILabel()
        label.text = "Ooops, nothing found"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .black
        return label
    }()
    
    let loading = LoadingUIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews function
    private func addSubviews() {
        addSubview(searchEmptyText)
        addSubview(searchTextField)
        addSubview(searchMoviesCollectionView)
        addSubview(comingSoonCollectionView)
        addSubview(loading)
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
        
        searchEmptyText.snp.makeConstraints { make in
            make.edges.equalTo(searchMoviesCollectionView)
        }
        
        searchMoviesCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(15)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        loading.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
