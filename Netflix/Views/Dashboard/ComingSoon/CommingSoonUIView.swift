import UIKit
import SnapKit

final class ComingSoonUIView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cellsData: UpcomingMoviesResponseModel?
    
    // Create category name for coming soon movies view
    private let searchTextField: UITextField = {
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
    private lazy var comingSoonCollectionView = UICollectionView()
    
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
    func updateUICollectionView(with cellsData: UpcomingMoviesResponseModel) {
        self.cellsData = cellsData
        self.comingSoonCollectionView.reloadData()
    }
    
    // Configure collection view for coming soon movies view
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        comingSoonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        comingSoonCollectionView.register(CustomComingSoonCollectionViewCell.self,
                                             forCellWithReuseIdentifier: CustomComingSoonCollectionViewCell.identifier)
        comingSoonCollectionView.dataSource = self
        comingSoonCollectionView.delegate = self
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

// Set settings functions
extension ComingSoonUIView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.cellsData?.results?.count {
            return count
        }
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomComingSoonCollectionViewCell.identifier, for: indexPath)
        if let cell = cell as? CustomComingSoonCollectionViewCell {
            if let posterPath = self.cellsData?.results?[indexPath.row].posterPath {
                cell.imageView.downloaded(from: "\(APIConstants.Api.urlImages)\(posterPath)", loadingView: cell.loading)
            }
    }
        return cell
    }

}
