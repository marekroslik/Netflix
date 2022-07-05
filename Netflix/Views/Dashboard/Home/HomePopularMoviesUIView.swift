import UIKit
import SnapKit

final class HomePopularMoviesUIView: UIView {
    
    // Create category name for popular movies view
    private let categoryName: UILabel = {
        let text = UILabel()
        text.text = "Popular Movies"
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        text.textColor = .white
        return text
    }()
    
    // Create collection view for popular movies view
    let popularMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 244)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.register(
            CustomPopularMoviesCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomPopularMoviesCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        applyConstraints()
    }
    
    // Add subviews fucntion
    private func addSubviews() {
        addSubview(categoryName)
        //        createCollectionView()
        addSubview(popularMoviesCollectionView)
    }
    
    // Set constraints function
    private func applyConstraints() {
        // Set category name constraints
        categoryName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        
        // Set popular moveies collection view
        popularMoviesCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(categoryName.snp.bottom)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
